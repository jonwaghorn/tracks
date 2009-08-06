class RegionController < ApplicationController

  before_filter :login_required, :only => [ :edit, :update, :new ]
  layout 'region', :except => [:rss]

  def index
    redirect_to :action => 'show', :id => Region.find(:first)
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :index }

  def show
    @region = Region.find(params[:id])
    @recent_track_reports = TrackReport.find_recent_by_region(params[:id])
    @markers = Area.get_markers(@region.id)
  end

  def new
    @region = Region.new
    @region.nation_id = params[:nation_id]
  end

  def create
    @region = Region.new(params[:region])
    @region.nation_id = params[:nation_id]
    if @region.save
      update_user_edit_stats
      @region.tweet_new
      flash[:notice] = @region.name + ' was successfully created.'
      redirect_to :controller => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @region = Region.find(params[:id])
    @region.description = replace_for_edit(@region.description)
  end

  def update
    @region = Region.find(params[:id])
    params[:region][:description] = replace_for_update(params[:region][:description])
    if @region.update_attributes(params[:region])
      update_user_edit_stats
      flash[:notice] = @region.name + ' was successfully updated.'
      redirect_to :action => 'show', :id => @region
    else
      render :action => 'edit'
    end
  end

  def rss
    @region = Region.find(params[:id])
    @track_reports = TrackReport.find_recent_by_region(@region.id)
    respond_to do |format|
      format.html
      format.rss  { render :layout => false }
    end
  end
end
