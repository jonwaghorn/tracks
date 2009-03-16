class FeaturesController < ApplicationController

  before_filter :login_required, :only => [ :new, :edit, :update ]

  # GET /features
  # GET /features.xml
  def index
    if params[:view]
      @features = Feature.completed_features
      @problems = Feature.completed_problems
    else
      @features = Feature.active_features
      @problems = Feature.active_problems
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @features }
    end
  end

  # GET /features/1
  # GET /features/1.xml
  def show
    @feature = Feature.find(params[:id])
    @comments = @feature.feature_comments

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @feature }
    end
  end

  # GET /features/new
  # GET /features/new.xml
  def new
    @feature = Feature.new
    @feature.kind = params[:kind] == 'problem' ? 'problem' : 'feature'

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @feature }
    end
  end

  # GET /features/1/edit
  def edit
    @feature = Feature.find(params[:id])
    @feature.description = replace_for_edit(@feature.description)
  end

  # POST /features
  # POST /features.xml
  def create
    @feature = Feature.new(params[:feature])
    @feature.user = current_user
    @feature.progress = Feature::PROGRESS[0]
    @feature.status = Feature::STATUSES[0]

    respond_to do |format|
      if @feature.save
        flash[:notice] = 'Feature was successfully created.'
        format.html { update_user_edit_stats; redirect_to(@feature) }
        format.xml  { render :xml => @feature, :status => :created, :location => @feature }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @feature.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /features/1
  # PUT /features/1.xml
  def update
    @feature = Feature.find(params[:id])
    params[:feature][:description] = replace_for_update(params[:feature][:description])

    respond_to do |format|
      if @feature.update_attributes(params[:feature])
        flash[:notice] = 'Feature was successfully updated.'
        if @feature.closed?
          Vote.delete_all(["feature_id = ?", @feature.id])
        end
        format.html { update_user_edit_stats; redirect_to(@feature) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feature.errors, :status => :unprocessable_entity }
      end
    end
  end

  def delete_vote
    @vote = Vote.find(params[:id])
    @vote.destroy

    @features = Feature.active_features
    @problems = Feature.active_problems
  end

  def create_vote
    @vote = Vote.new()
    @vote.feature_id = params[:feature].to_i
    @vote.user_id = params[:user].to_i
    @vote.save

    @features = Feature.active_features
    @problems = Feature.active_problems
  end

end
