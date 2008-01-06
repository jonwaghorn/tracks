class TrackReport < ActiveRecord::Base

  RECENT_TRACK_COUNT = 3
  RECENT_HISTORY_OFFSET = Time.now - 1.week

  def self.find_recent(limit = RECENT_TRACK_COUNT, offset = RECENT_HISTORY_OFFSET)
    previous_by_time = find(:all, :order => 'date DESC', :conditions => ["date > ?", offset])
    previous_by_time.length > limit ? previous_by_time : find(:all, :limit => limit, :order => 'date DESC')
  end

  def self.find_recent_by_track(track_id)
    previous_by_time = find(:all, :order => 'date DESC', :conditions => ["track_id = ? AND date > ?", track_id, RECENT_HISTORY_OFFSET])
    previous_by_time.length > RECENT_TRACK_COUNT ? previous_by_time : find(:all, :limit => RECENT_TRACK_COUNT, :order => 'date DESC', :conditions => ["track_id = ?", track_id])
  end
end
