class TrackConnectionController < ApplicationController
  before_filter :login_required

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create ],
         :redirect_to => { :action => :list }

  def create
    @track_connection = TrackConnection.new(params[:track_connection])
    @track_connection.track_id = params[:track_id]
    @track_connection.save
    update_user_edit_stats
    get_connections
    update_track # move to model?
    logger.info "Add track connection: #{Track.find(@track_connection.connect_track_id).name} (id:#{@track_connection.connect_track_id}) added to #{@track.name} (id:#{@track.id})"
  end

  def edit
    get_connections
  end

  def done
    get_connections
  end

  def destroy
    @track_connection = TrackConnection.find(params[:id])
    @track_connection.destroy
    update_user_edit_stats
    get_connections
    update_track # move to model?
    logger.info "Delete track connection: #{Track.find(@track_connection.connect_track_id).name} (id:#{@track_connection.connect_track_id}) removed from #{@track.name} (id:#{@track.id})"
  end
  
private

  def get_connections
    @track = Track.find(params[:track_id])
    @existing_connections = @track.get_connections
    @potential_connections_all = Track.find(:all, :select => 'name, id', :order => 'name', :conditions => ["id not in (?)", @track.track_connections.collect(&:connect_track_id) << @track.id])
    @potential_connections_same_area = Track.find(:all, :select => 'name, id', :order => 'name', :conditions => ["id not in (?) AND area_id = ?", @track.track_connections.collect(&:connect_track_id) << @track.id, @track.area_id])
    @potential_connections_same_region = Track.find(:all, :select => 'name, id', :order => 'name', :conditions => ["id not in (?) AND area_id in (?)", @track.track_connections.collect(&:connect_track_id) << @track.id, @track.area.region.areas.collect(&:id)])
  end

  def update_track
    @track.updated_by = current_user.id
    @track.save
  end
end
