class FaqController < ApplicationController

  layout 'shared'

  before_filter :login_required, :only => [ :edit, :update, :new ]
  before_filter :set_title

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
  :redirect_to => { :action => :index }

  def list
    @faqs = Faq.find(:all, :order => "category, question ASC")
  end

  def show
    @faq = Faq.find(params[:id])
  end

  def new
    @faq = Faq.new
    @categories = Faq.find(:all, :select => 'category', :group => 'category')
  end

  def create
    @faq = Faq.new(params[:faq])
    @faq.user_id = current_user.id
    if @faq.save
      update_user_edit_stats
      flash[:notice] = 'FAQ was successfully created.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @faq = Faq.find(params[:id])
    @faq.answer = replace_for_edit(@faq.answer)
    @categories = Faq.find(:all, :select => 'category', :group => 'category')
  end

  def update
    @faq = Faq.find(params[:id])
    params[:faq][:answer] = replace_for_update(params[:faq][:answer])
    if @faq.update_attributes(params[:faq])
      update_user_edit_stats
      flash[:notice] = 'FAQ was successfully updated.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Faq.find(params[:id]).destroy
    update_user_edit_stats
    redirect_to :action => 'index'
  end
  
  def set_title
    @title = 'FAQ'
  end
end
