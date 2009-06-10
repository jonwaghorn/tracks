class AccountController < ApplicationController
  layout 'shared'
  before_filter :set_title

  # If you want "remember me" functionality, add this before_filter to Application Controller
  # before_filter :login_from_cookie

  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless logged_in? || User.count > 0
  end

  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => '/index', :action => 'index')
    else
      flash[:notice] = "Problem with log in, re-enter your username and password"
    end
  end

  def signup
    @user = User.new(params[:user])
    return unless request.post?
    if @user.valid_with_captcha?
      @user.save!
      self.current_user = @user
      flash[:notice] = "Thanks for signing up!"
      redirect_back_or_default(:controller => '/index', :action => 'index')
    else
      return
    end
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/index', :action => 'index')
  end

  def change_password
    flash[:notice] = ""
  end

  def update_password
    if User.authenticate(current_user.login, params[:user][:old_password])
      if (params[:user][:password] == params[:user][:password_confirmation])
        if (params[:user][:password].empty?)
          flash[:notice] = "New password can't be empty"
          @old_password = params[:user][:old_password]
          render :action => 'change_password'
        else
          current_user.password_confirmation = params[:user][:password_confirmation]
          current_user.password = params[:user][:password]
          if current_user.save
            flash[:notice] = "Password changed"
          end
          @user = current_user
        end
      else
        flash[:notice] = "Password mismatch"
        @old_password = params[:user][:old_password]
        render :action => 'change_password'
      end
    else
      flash[:notice] = "Old password wrong"
      render :action => 'change_password'
    end
  end

  def cancel_change_password
    flash[:notice] = ""
    @user = current_user
  end

  def set_title
    @title = 'Account'
  end
end
