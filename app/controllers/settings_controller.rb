class SettingsController < ApplicationController

  before_filter :login_required

  def index
    show
    render :action => 'show'
  end

  def show
    @setting = Setting.find(current_user.id)
  end

  def edit
    @setting = Setting.find(current_user.id)
  end

  def update
    @setting = Setting.find(current_user.id)

    if @setting.update_attributes(params[:setting])
      flash[:notice] = 'Settings saved.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

end
