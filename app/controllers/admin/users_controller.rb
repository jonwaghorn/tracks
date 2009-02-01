class Admin::UsersController < ApplicationController
  before_filter :admin_required
  layout 'admin'

  def index
    @users = User.find(:all, :order => 'last_track_edit_at DESC, created_at DESC')
  end

  def show
    @user = User.find(params[:id])
  end
end
