class AdminController < ApplicationController

  before_filter :admin_required

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :index }

  def index
    @users = User.find(:all, :order => 'last_track_edit_at DESC, created_at DESC')
  end

end
