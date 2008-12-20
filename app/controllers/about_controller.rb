class AboutController < ApplicationController

  before_filter :login_required, :only => [ :edit, :update ]

  def index
    @special = Special.find(:first, :conditions => ["name = ?", 'about'])
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
    update_user_edit_stats
    if @special.update_attributes(params[:special])
      flash[:notice] = 'About was successfully updated.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def issue_site_update
    tweet("site update, more info at http://#{URL_BASE}/about")
    flash[:notice] = 'Site update notification sent (via Twitter).'
    redirect_to :action => 'index'
  end
end
