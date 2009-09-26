class Admin::UsersController < ApplicationController

  layout 'shared'

  before_filter :admin_required
  before_filter :set_title

  def index
    @filter = params[:filter].nil? ? 'all' : params[:filter]
    s = @filter == 'all' ? %w(viewer creator admin) : @filter == 'creator' ? %w(creator admin) : @filter
    @users = User.paginate :page => params[:page], :conditions => ['privilege in (?)', s.to_a], :order => 'last_track_edit_at DESC, created_at DESC'
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

  def show_signups
    @users = User.paginate :page => params[:page], :order => 'created_at DESC'
    @signups = User.find(:all, :conditions => ['created_at > ?', 1.year.ago], :order => 'created_at DESC')
    @signup_months = @signups.group_by { |t| t.created_at.beginning_of_month }
  end

  def edit_password
    @user = User.find(params[:id])
  end

  def update_password
    @user = User.find(params[:id])
    params[:user][:password_confirmation] = params[:user][:password]
    # puts params[:user].inspect
    if @user.update_attributes(params[:user])
      flash[:notice] = @user.screen_name + ' password set.'
      redirect_to :action => 'show', :id => @user
    else
      render :action => 'edit_password'
    end
  end

  def set_title
    @title = 'ADMIN'
  end
end
