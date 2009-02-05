class Admin::UsersController < ApplicationController
  before_filter :admin_required
  layout 'admin'

  def index
    @users = User.find(:all, :order => 'last_track_edit_at DESC, created_at DESC')
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = @user.screen_name + ' was successfully updated.'
      redirect_to :action => 'show', :id => @user
    else
      render :action => 'edit'
    end
  end
end
