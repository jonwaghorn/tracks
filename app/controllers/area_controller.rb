class AreaController < ApplicationController

  before_filter :login_required, :only => [ :edit, :update, :new ]

  def index
    redirect_to :action => 'show', :id => Area.find(:first)
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :index }

  def show
    @area = Area.find(params[:id])
  end

  def new
    @area = Area.new
    @area.region_id = params[:region_id]
  end

  def create
    @area = Area.new(params[:area])
    @area.region_id = params[:region_id]
    if @area.save
      update_user_edit_stats
      @area.tweet_new
      flash[:notice] = @area.name + ' was successfully created.'
      redirect_to :controller => 'area', :action => 'show', :id => @area
    else
      render :action => 'new'
    end
  end

  def edit
    @area = Area.find(params[:id])
    @area.description = replace_for_edit(@area.description)
  end

  def update
    @area = Area.find(params[:id])
    params[:area][:description] = replace_for_update(params[:area][:description])
    if @area.update_attributes(params[:area])
      update_user_edit_stats
      flash[:notice] = @area.name + ' was successfully updated.'
      redirect_to :action => 'show', :id => @area
    else
      render :action => 'edit'
    end
  end

  def destroy
    Area.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
