class AreaController < ApplicationController
  include ApplicationHelper

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
  end

  def create
    @area = Area.new(params[:area])
    @area.state_id = params[:state_id]
    @area.date = Time.now
    update_user_edit_stats(current_user.id)
    if @area.save
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
    @area.date = Time.now
    params[:area][:description] = replace_for_update(params[:area][:description])
    update_user_edit_stats(current_user.id)
    if @area.update_attributes(params[:area])
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
