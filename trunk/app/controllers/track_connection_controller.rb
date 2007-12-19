class TrackConnectionController < ApplicationController
  before_filter :login_required

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create ],
         :redirect_to => { :action => :list }

  def new
    @track_connection = TrackConnection.new
    @track_connection.track_id = params[:track_id]
  end

  def create
    @track_connection = TrackConnection.new(params[:track_connection])
    @track_connection.track_id = params[:track_id]
    if @track_connection.save
      flash[:notice] = 'Successfully added connecting track ' + Track.find(@track_connection.connect_track_id, :select => "name").name + '.'
      redirect_to :controller => 'track', :action => 'edit', :id => params[:track_id]
    else
      render :action => 'new'
    end
  end

  def destroy
    tc = TrackConnection.find(params[:id])
    flash[:notice] = 'Removed connecting track ' + Track.find(tc.connect_track_id, :select => "name").name + '.'
    tc.destroy
    redirect_to :controller => 'track', :action => 'edit', :id => params[:track_id]
  end
end
