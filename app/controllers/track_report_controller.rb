class TrackReportController < ApplicationController
  include ApplicationHelper

  before_filter :login_required, :only => [ :edit, :update, :new, :login ]

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def new
    @track_report = TrackReport.new
    @track = Track.find(params[:track_id])
  end

  def login
    redirect_to :controller => 'track', :action => 'show', :id => params[:track_id]
  end

  def create
    @track_report = TrackReport.new(params[:track_report])
    if @track_report.description.length > 0
      @track_report.track_id = params[:track_id]
      @track_report.description = replace_for_update(@track_report.description)
      @track_report.user_id = current_user.id
      @track_report.date = Time.now
      update_track_edit_stats
      @track_report.save
      @new_track_id = @track_report.id # my rjs doesn't get the proper id...
      @track = Track.find(params[:track_id])
    else
      redirect_to :action => 'cancel', :track_id => params[:track_id]
    end
  end

  def edit
    @track_report = TrackReport.find(params[:id])
    @track_report.description = replace_for_edit(@track_report.description)
    @track = Track.find(@track_report.track_id)
  end

  def update
    @track_report = TrackReport.find(params[:id])
    params[:track_report][:description] = replace_for_update(params[:track_report][:description])
    @track_report.user_id = current_user.id
    @track_report.date = Time.now
    if params[:track_report][:description].length > 0
      @track_report.update_attributes(params[:track_report])
      update_track_edit_stats
    end
  end

  def destroy
    track_report = TrackReport.find(params[:id]).destroy
  end

  def cancel
    @track = Track.find(params[:track_id])
  end

  def cancel_edit
    @track_report = TrackReport.find(params[:id])
    @track = Track.find(@track_report.track_id)
  end

  def update_track_edit_stats
    @user = User.find(current_user.id)
    @user.reports += 1
    @user.last_track_edit_at = Time.now
    @user.save
  end

end
