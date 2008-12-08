class IndexController < ApplicationController
  include ApplicationHelper

  before_filter :login_required, :only => [ :edit, :update ]

  def index
    @special = Special.find(:first, :conditions => ["name = ?", 'index'])
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :index }

  def edit
    @special = Special.find(params[:id])
    @special.content = replace_for_edit(@special.content)
  end

  def update
    @special = Special.find(params[:id])
    params[:special][:content] = replace_for_update(params[:special][:content])
    update_user_edit_stats(current_user.id)
    if @special.update_attributes(params[:special])
      flash[:notice] = 'Home was successfully updated.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def rss
    @track_reports = TrackReport.find_recent(limit = 5)
    # render :layout => false

    respond_to do |format|
      format.html
      format.rss  { render :layout => false }
    end
  end

end
