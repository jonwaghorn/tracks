class SettingsController < ApplicationController

  before_filter :login_required

  def index
    show
    render :action => 'show'
  end

  def show
    @user = current_user
    @setting = Setting.find(current_user.id)
  end

  # ---

  def edit_prefs
    @setting = Setting.find(current_user.id)
  end
  
  def cancel_edit_prefs
    @setting = Setting.find(current_user.id)
  end

  def update_prefs
    @setting = Setting.find(current_user.id)

    if !@setting.update_attributes(params[:setting])
      render :action => 'edit_prefs'
    end
  end

  # ---

  def edit_user_settings
    @user = User.find(current_user.id)
  end
  
  def cancel_edit_user_settings
    @user = User.find(current_user.id)
  end

  def update_user_settings
    @user = User.find(current_user.id)
    @current_user = @user # hack
    # @user.login = params[:user][:login]
    @user.screen_name = params[:user][:screen_name]

    if !@user.save
      render :action => 'edit_user_settings'
    else
      current_user = @user
    end
  end

end
