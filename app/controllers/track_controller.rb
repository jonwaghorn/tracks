class TrackController < ApplicationController

  before_filter :login_required, :only => [ :edit, :update, :new ]

  def index
    redirect_to :action => 'show', :id => Track.find(:first)
  end
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
  :redirect_to => { :action => :index }

  def show
    @track = Track.find(params[:id])
    @track_akas = TrackAka.find(:all, :conditions => ["track_id = ?", @track.id])
    @existing_connections = @track.get_connections
    @ref_id = @track.id
  end

  def new
    @track = Track.new
    @track.area_id = params[:area_id]
  end

  def create
    @track = Track.new(params[:track])
    @track.area_id = params[:area_id]
    @track.created_by = current_user.id
    @track.updated_by = current_user.id
    if @track.save
      update_user_edit_stats
      @track.tweet_new
      flash[:notice] = @track.name + ' was successfully created.'
      redirect_to :action => 'show', :id => @track
    else
      render :action => 'new'
    end
  end

  def edit
    @track = Track.find(params[:id])
    @track.desc_overview = replace_for_edit(@track.desc_overview)
    @track.desc_full = replace_for_edit(@track.desc_full)
    @track.desc_where = replace_for_edit(@track.desc_where)
    @track.desc_note = replace_for_edit(@track.desc_note)
    @existing_connections = @track.get_connections
  end

  def update
    @track = Track.find(params[:id])
    params[:track][:desc_overview] = replace_for_update(params[:track][:desc_overview])
    params[:track][:desc_full] = replace_for_update(params[:track][:desc_full])
    params[:track][:desc_where] = replace_for_update(params[:track][:desc_where])
    params[:track][:desc_note] = replace_for_update(params[:track][:desc_note])
    @track.updated_by = current_user.id
    @existing_connections = @track.get_connections
    if @track.update_attributes(params[:track])
      update_user_edit_stats
      flash[:notice] = @track.name + ' was successfully updated.'
      redirect_to :action => 'show', :id => @track
    else
      render :action => 'edit'
    end
  end

  def upload
    @track = Track.find(params[:id])
  end

  def cancel_upload
    @track = Track.find(params[:id])
  end

  def manual_track_length
    @track = Track.find(params[:id])
  end

  def save_path
    @track = Track.find(params[:id])
    begin
      File.open("#{@track.full_filename}.kml", "wb") do |f|
        f.write(params[:path][:filename].read)
      end
      @track.updated_by = current_user.id
      @track.process_kml_path(open("#{@track.full_filename}.kml") { |f| Hpricot(f) })
    rescue Errno::ENOENT
      flash[:notice] = 'Problem uploading file. Please check your file and try again.'
    end
    redirect_to :action => 'show', :id => @track.id
  end

  def destroy
    track = Track.find(params[:id]).destroy
    redirect_to :controller => 'area', :action => 'show', :id => track.area_id
  end
end
