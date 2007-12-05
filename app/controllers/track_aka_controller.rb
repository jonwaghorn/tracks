class TrackAkaController < ApplicationController
  before_filter :login_required

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def show
    @track_aka = TrackAka.find(params[:id])
  end

  def new
    @track_aka = TrackAka.new
    @track_aka.track_id = params[:track_id]
  end

  def create
    @track_aka = TrackAka.new(params[:track_aka])
    @track_aka.track_id = params[:track_id]
    if @track_aka.save
      flash[:notice] = 'Successfully added \'also known as\' ' + @track_aka.name + '.'
      redirect_to :controller => 'track', :action => 'edit', :id => params[:track_id]
    else
      render :action => 'new'
    end
  end

  def edit
    @track_aka = TrackAka.find(params[:id])
  end

  def update
    @track_aka = TrackAka.find(params[:id])
    track = Track.find(@track_aka.track_id)
    if @track_aka.update_attributes(params[:track_aka])
      flash[:notice] = @track_aka.name + ' \'also known as\' was successfully updated.'
      redirect_to :controller => 'track', :action => 'edit', :id => track
    else
      render :action => 'edit'
    end
  end

  def destroy
    TrackAka.find(params[:id]).destroy
    redirect_to :controller => 'track', :action => 'edit', :id => params[:track_id]
  end
end
