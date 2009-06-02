class PolicyController < ApplicationController

  layout 'shared'

  before_filter :login_required, :only => [ :edit, :update ]
  before_filter :set_title

  def index
    @special = Special.find(:first, :conditions => ["name = ?", 'policy'])
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
    if @special.update_attributes(params[:special])
      update_user_edit_stats
      flash[:notice] = 'Privacy Policy was successfully updated.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def set_title
    @title = 'Terms/Privacy'
  end
end
