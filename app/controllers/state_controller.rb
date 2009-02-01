class StateController < ApplicationController

  before_filter :login_required, :only => [ :edit, :update, :new ]
  layout 'state', :except => [:rss]

  def index
    redirect_to :action => 'show', :id => State.find(:first)
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :index }

  def show
    @state = State.find(params[:id])
    @recent_track_reports = TrackReport.find_recent_by_state(params[:id])
  end

  def new
    @state = State.new
    @state.nation_id = params[:nation_id]
  end

  def create
    @state = State.new(params[:state])
    @state.date = Time.now
    @state.nation_id = params[:nation_id]
    if @state.save
      update_user_edit_stats
      @state.tweet_new
      flash[:notice] = @state.name + ' was successfully created.'
      redirect_to :controller => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @state = State.find(params[:id])
    @state.description = replace_for_edit(@state.description)
  end

  def update
    @state = State.find(params[:id])
    params[:state][:description] = replace_for_update(params[:state][:description])
    @state.date = Time.now
    if @state.update_attributes(params[:state])
      update_user_edit_stats
      flash[:notice] = @state.name + ' was successfully updated.'
      redirect_to :action => 'show', :id => @state
    else
      render :action => 'edit'
    end
  end

  def rss
    @state = State.find(params[:id])
    @track_reports = TrackReport.find_recent_by_state(@state.id)
    respond_to do |format|
      format.html
      format.rss  { render :layout => false }
    end
  end
end
