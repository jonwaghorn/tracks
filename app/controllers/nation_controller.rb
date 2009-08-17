class NationController < ApplicationController

  before_filter :login_required, :only => [ :edit, :update, :edit_regions, :region_up, :region_down ]

  def index
    redirect_to :action => 'show', :id => Nation.find(:first)
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :index }

  def show
    @nation = Nation.find(params[:id])
  end

  def edit
    @nation = Nation.find(params[:id])
    @nation.description = replace_for_edit(@nation.description)
  end

  def update
    @nation = Nation.find(params[:id])
    params[:nation][:description] = replace_for_update(params[:nation][:description])
    if @nation.update_attributes(params[:nation])
      update_user_edit_stats
      flash[:notice] = @nation.name + '  was successfully updated.'
      redirect_to :action => 'show', :id => @nation
    else
      render :action => 'edit'
    end
  end

  def edit_regions
    @nation = Nation.find(params[:id])
  end

  def region_up
    @nation = Nation.find(params[:id])
    @nation.region_up(params[:posn].to_i)
    @nation = Nation.find(params[:id]) # reload
  end

  def region_down
    @nation = Nation.find(params[:id])
    @nation.region_down(params[:posn].to_i)
    @nation = Nation.find(params[:id]) # reload
  end
end
