class Track < ActiveRecord::Base
  belongs_to :area
  has_many :track_akas
  belongs_to :track_grade
  belongs_to :track_access
  belongs_to :condition
  has_many :track_connections

  RECENT_TRACK_COUNT = 3
  RECENT_HISTORY_OFFSET = 60 * 60 * 24 * 7 # one week

  def self.find_recent
    previous_by_time = find(:all, :order => 'date DESC', :conditions => ["date > ?", Time.now - RECENT_HISTORY_OFFSET])
    previous_by_time.length > RECENT_TRACK_COUNT ? previous_by_time : find(:all, :limit => RECENT_TRACK_COUNT, :order => 'date DESC')
  end

  def self.find_recent_by(area_id)
    previous_by_time = find(:all, :order => 'date DESC', :conditions => ["area_id = ? AND date > ?", area_id, Time.now - RECENT_HISTORY_OFFSET])
    previous_by_time.length > RECENT_TRACK_COUNT ? previous_by_time : find(:all, :limit => RECENT_TRACK_COUNT, :order => 'date DESC', :conditions => ["area_id = ?", area_id])
  end
end
