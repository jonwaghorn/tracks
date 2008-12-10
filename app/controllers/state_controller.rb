class StateController < ApplicationController
  include ApplicationHelper

  before_filter :login_required, :only => [ :edit, :update, :new ]

  def index
    redirect_to :action => 'show', :id => State.find(:first)
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :index }

  def show
    @state = State.find(params[:id])
  end

  def new
    @state = State.new
  end

  def create
    @state = State.new(params[:state])
    @state.date = Time.now
    update_user_edit_stats
    if @state.save
      flash[:notice] = @state.name + ' was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @state = State.find(params[:id])
    @state.description = replace_for_edit(@state.description)
  end

  def update
    @state = State.find(params[:id])
    params[:state][:description] = replace_for_update(params[:state][:description])
    @state.date = Time.now
    update_user_edit_stats
    if @state.update_attributes(params[:state])
      flash[:notice] = @state.name + ' was successfully updated.'
      redirect_to :action => 'show', :id => @state
    else
      render :action => 'edit'
    end
  end

  def destroy
    State.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
