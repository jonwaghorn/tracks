class TrackReport < ActiveRecord::Base

  include TwitterHelper
  include TextHelper

  belongs_to :track

  RECENT_TRACK_COUNT = 5
  RECENT_HISTORY_OFFSET = Time.now - 1.week

  def self.find_recent(offset = RECENT_HISTORY_OFFSET)
    previous_by_time = find(:all, :order => 'updated_at DESC', :conditions => ["updated_at > ?", offset])
    previous_by_time.length > RECENT_TRACK_COUNT ? previous_by_time : find(:all, :limit => RECENT_TRACK_COUNT, :order => 'updated_at DESC')
  end

  def self.find_recent_by_track(track_id)
    previous_by_time = find(:all, :order => 'updated_at DESC', :conditions => ["track_id = ? AND updated_at > ?", track_id, RECENT_HISTORY_OFFSET])
    previous_by_time.length > RECENT_TRACK_COUNT ? previous_by_time : find(:all, :limit => RECENT_TRACK_COUNT, :order => 'updated_at DESC', :conditions => ["track_id = ?", track_id])
  end

  def self.find_recent_by_region(region_id)
    track_ids = []
    Region.find(region_id).areas.each do |a|
      track_ids << a.tracks.collect(&:id)
    end
    previous_by_time = find(:all, :order => 'updated_at DESC', :conditions => ["track_id in (?) AND updated_at > ?", track_ids.flatten, RECENT_HISTORY_OFFSET])
    previous_by_time.length > RECENT_TRACK_COUNT ? previous_by_time : find(:all, :limit => RECENT_TRACK_COUNT, :order => 'updated_at DESC', :conditions => ["track_id in (?)", track_ids.flatten])
  end

  # Shoe-horn track name, report (some of), and url to track
  def format_for_twitter
    url = shorten_url "http://#{URL_BASE}/track/show/#{track.id}"
    non_message_len = track.name.length + 2 + 1 + url.length
      message = replace_for_view(description, unlinked = true).chomp.strip
    track.name + ': ' + message[0, 140 - non_message_len] + ' ' + url
  end
end
