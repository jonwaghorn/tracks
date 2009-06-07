class TrackReportController < ApplicationController

  layout 'shared'

  before_filter :login_required, :only => [ :edit, :update, :new, :login ]
  before_filter :set_title

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def index
   list
   render :action => 'list'
  end

  def list
    @track_reports = TrackReport.find(:all, :order => 'updated_at DESC', :conditions => ["track_id = ? and updated_at > ? and updated_at < ?", params[:track_id], params[:year] + '-01-01 00:00:00', params[:year] + '-12-31 23:59:59'])
    @oldest_report = TrackReport.find(:first, :conditions => ['track_id = ?', params[:track_id]], :order => 'updated_at ASC')
  end

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
      @track_report.save
      update_user_edit_stats(true)
      tweet @track_report.format_for_twitter
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
    if params[:track_report][:description].length > 0
      @track_report.update_attributes(params[:track_report])
      update_user_edit_stats(true)
    end
  end

  def destroy
    track_report = TrackReport.find(params[:id]).destroy
    update_user_edit_stats(true)
  end

  def cancel
    @track = Track.find(params[:track_id])
  end

  def cancel_edit
    @track_report = TrackReport.find(params[:id])
    @track = Track.find(@track_report.track_id)
  end

  def show_report
    @track_report = TrackReport.find(params[:id])
  end

  def set_title
    @title = 'Track Reports'
  end
end
