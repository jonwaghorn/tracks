class TrackReportController < ApplicationController
  include ApplicationHelper

  before_filter :login_required, :only => [ :edit, :update, :new ]

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def new
    @track_report = TrackReport.new
  end

  def create
    @track_report = TrackReport.new(params[:track_report])
    @track_report.track_id = params[:track_id]
    @track_report.description = replace_for_update(@track_report.description)
    @track_report.user_id = current_user.id
    @track_report.date = Time.now
    if @track_report.save
      flash[:notice] = 'Track report was successfully added.'
      redirect_to :controller => 'track', :action => 'show', :id => params[:track_id]
    else
      render :action => 'new'
    end
  end

  def edit
    @track_report = TrackReport.find(params[:id])
    @track_report.description = replace_for_edit(@track_report.description)
  end

  def update
    @track_report = TrackReport.find(params[:id])
    params[:track_report][:description] = replace_for_update(params[:track_report][:description])
    @track_report.user_id = current_user.id
    @track_report.date = Time.now
    if @track_report.update_attributes(params[:track_report])
      flash[:notice] = 'Track report was successfully updated.'
      redirect_to :controller => 'track', :action => 'show', :id => @track_report.track_id
    else
      render :action => 'edit'
    end
  end

  def destroy
    track_report = TrackReport.find(params[:id]).destroy
    redirect_to :controller => 'track', :action => 'show', :id => track_report.track_id
  end
end
