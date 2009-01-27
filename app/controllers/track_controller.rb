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
    @existing_connections = @track.get_connections
  end

  def new
    @track = Track.new
  end

  def create
    @track = Track.new(params[:track])
    @track.area_id = params[:area_id]
    @track.author = current_user.id
    @track.date = Time.now
    update_user_edit_stats
    if @track.save
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
    @track.author = current_user.id
    update_user_edit_stats
    @track.date = Time.now
    @existing_connections = @track.get_connections
    if @track.update_attributes(params[:track])
      flash[:notice] = @track.name + ' was successfully updated.'
      redirect_to :action => 'show', :id => @track
    else
      render :action => 'edit'
    end
  end

  def upload
    @track = Track.find(params[:id])
  end

  def save_path
    @track = Track.find(params[:id])
    File.open("#{@track.full_filename}.kml", "wb") do |f|
      f.write(params[:path_file].read)
    end
    redirect_to :action => 'show', :id => @track.id
  end

  def destroy
    track = Track.find(params[:id]).destroy
    redirect_to :controller => 'area', :action => 'show', :id => track.area_id
  end
end
