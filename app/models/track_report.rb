class TrackReport < ActiveRecord::Base

  RECENT_TRACK_COUNT = 3
  RECENT_HISTORY_OFFSET = 60 * 60 * 24 * 7 # one week

  def self.find_recent(track_id)
    previous_by_time = find(:all, :order => 'date DESC', :conditions => ["track_id = ? AND date > ?", track_id, Time.now - RECENT_HISTORY_OFFSET])
    previous_by_time.length > RECENT_TRACK_COUNT ? previous_by_time : find(:all, :limit => RECENT_TRACK_COUNT, :order => 'date DESC', :conditions => ["track_id = ?", track_id])
  end
end
