class NationController < ApplicationController
  include ApplicationHelper

  before_filter :login_required, :only => [ :edit, :update, :new ]

  def index
    redirect_to :action => 'show', :id => Nation.find(:first)
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :index }

  def show
    @nation = Nation.find(params[:id])
  end

  def new
    @nation = Nation.new
  end

  def create
    @nation = Nation.new(params[:nation])
    @nation.date = Time.now
    update_user_edit_stats
    if @nation.save
      flash[:notice] = @nation.name + ' was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @nation = Nation.find(params[:id])
    @nation.description = replace_for_edit(@nation.description)
  end

  def update
    @nation = Nation.find(params[:id])
    params[:nation][:description] = replace_for_update(params[:nation][:description])
    @nation.date = Time.now
    update_user_edit_stats
    if @nation.update_attributes(params[:nation])
      flash[:notice] = @nation.name + '  was successfully updated.'
      redirect_to :action => 'show', :id => @nation
    else
      render :action => 'edit'
    end
  end

  def destroy
    Nation.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
