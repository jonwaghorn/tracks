# == Schema Information
# Schema version: 20090930170613
#
# Table name: tracks
#
#  id                    :integer(4)      not null, primary key
#  name                  :string(40)      default(""), not null
#  area_id               :integer(4)
#  access_note           :string(255)
#  desc_overview         :text
#  desc_full             :text
#  desc_where            :text
#  desc_note             :text
#  length                :decimal(6, 3)   default(0.0)
#  alt_gain              :integer(4)
#  alt_loss              :integer(4)
#  alt_begin             :integer(4)
#  alt_end               :integer(4)
#  alt_note              :string(255)
#  grade_note            :string(255)
#  created_at            :datetime
#  updated_by            :integer(4)
#  latitude              :decimal(9, 6)   default(0.0)
#  longitude             :decimal(9, 6)   default(0.0)
#  zoom                  :integer(4)      default(0), not null
#  track_grade_id        :integer(4)
#  track_access_id       :integer(4)
#  condition_id          :integer(4)
#  created_by            :integer(4)
#  updated_at            :datetime
#  length_source         :string(255)
#  length_adjust_percent :integer(4)      default(0)
#

class Track < ActiveRecord::Base

  require 'gmap_polyline_encoder'
  require 'hpricot'
  include TwitterHelper
  include TextHelper
  include Coords

  belongs_to :area
  has_many :track_akas, :order => 'name'
  belongs_to :track_grade
  belongs_to :track_access
  belongs_to :condition
  has_many :track_connections
  has_many :track_reports
  has_many :g_map_tracks, :order => 'sequence'
  # has_many :medias, :conditions => ["ref_type = ? AND ref_id = ?", 'track', id]

  before_validation       :fix_name
  validates_presence_of   :name
  validates_format_of     :name, :with => /^[\w ']+$/i, :message => 'can only contain letters and numbers (and spaces).'
  validates_length_of     :name, :maximum => 40, :message => 'Track name too long, maximum is 40 characters.'
  validate                :name_is_unique_for_region
  validate                :overview_is_not_empty

  RECENT_TRACK_COUNT = 5
  RECENT_HISTORY_OFFSET = Time.now - 1.week
  Track::LENGTH_SOURCE_CALC = 'calc'
  Track::LENGTH_SOURCE_USER = 'user'

  def medias
    Media.find(:all, :conditions => ["ref_type = ? AND ref_id = ?", 'track', id])
  end

  # Apply % adjustment for calculated lengths
  def adjusted_length
    return length if length_source == LENGTH_SOURCE_USER
    (length * (100 + length_adjust_percent)) / 100
  end

  def self.find_recent(offset = RECENT_HISTORY_OFFSET)
    previous_by_time = find(:all, :order => 'updated_at DESC', :conditions => ["updated_at > ?", offset])
    previous_by_time.length > RECENT_TRACK_COUNT ? previous_by_time : find(:all, :limit => RECENT_TRACK_COUNT, :order => 'updated_at DESC')
  end

  def self.find_recent_by_area(area_id)
    previous_by_time = find(:all, :order => 'updated_at DESC', :conditions => ["area_id = ? AND updated_at > ?", area_id, RECENT_HISTORY_OFFSET])
    previous_by_time.length > RECENT_TRACK_COUNT ? previous_by_time : find(:all, :limit => RECENT_TRACK_COUNT, :order => 'updated_at DESC', :conditions => ["area_id = ?", area_id])
  end

  def self.find_recent_by_region(region_id)
    track_ids = []
    Region.find(region_id).areas.each do |a|
      track_ids << a.tracks.collect(&:id)
    end

    previous_by_time = find(:all, :order => 'updated_at DESC', :conditions => ["id in (?) AND updated_at > ?", track_ids.flatten, RECENT_HISTORY_OFFSET])
    previous_by_time.length > RECENT_TRACK_COUNT ? previous_by_time : find(:all, :limit => RECENT_TRACK_COUNT, :order => 'updated_at DESC', :conditions => ["id in (?)", track_ids.flatten])

    # previous_by_time = find(:all, :order => 'updated_at DESC', :conditions => ["area_id = ? AND updated_at > ?", area_id, RECENT_HISTORY_OFFSET])
    # previous_by_time.length > RECENT_TRACK_COUNT ? previous_by_time : find(:all, :limit => RECENT_TRACK_COUNT, :order => 'updated_at DESC', :conditions => ["area_id = ?", area_id])
  end

  def file_path_exists?
    FileTest.exist?(full_filename)
  end
  
  def filename
    "#{id}"
  end
  
  def full_filename
    "paths/" + filename
  end

  def gps_file_exists?
    gpx_file_exists? || kml_file_exists?
  end

  def gpx_file_exists?
    File.exists?("#{full_filename}.gpx")
  end

  def kml_file_exists?
    File.exists?("#{full_filename}.kml")
  end

  def process_kml_path(doc)
    GMapTrack.delete(g_map_tracks)
    main_name = doc.search('name').first
    main_name = main_name.nil? ? name : main_name.inner_html
    len = 0.0

    # Go through each 'placemark', get name and then process the coordinates
    doc.search("placemark").each_with_index do |placemark, i|
      sub_name = placemark.search('name')
      sub_name = sub_name.nil? ? name : sub_name.inner_html
      next if placemark.search('linestring').empty?
      placemark.search('coordinates').each do |path|
        data = []
        path.inner_html.gsub(/\r/,'').gsub(/\n/,' ').split(" ").each do |coord|
          coord.strip!
          next if coord.empty?
          lng,lat,alt = coord.split(",")
          data << [lat.to_f,lng.to_f]
        end

        encoder = GMapPolylineEncoder.new()
        result = encoder.encode(data)

        len += calculate_path_length(data)/1000

        # sub_name = name if sub_name.nil?

        GMapTrack.new(:track_id => id, :points => result[:points], :levels => result[:levels], :num_levels => result[:numLevels], :zoom => result[:zoomFactor], :sequence => i, :name => sub_name).save!
      end
    end

    self.length = len
    self.length_source = LENGTH_SOURCE_CALC
    self.length_adjust_percent = 5
    self.save!
  end

  # Track connections in array of [connecting_track_name,connection_id,track_id]
  def get_connections
    connections = []
    track_connections.each do |c|
      connections << [Track.find(c.connect_track_id, :select => "name").name, c.id, c.connect_track_id]
    end
    connections.sort
  end

  def self.get_markers(area_id)
    find(:all, :conditions => ["area_id = ? AND zoom != 0", area_id], :select => 'latitude, longitude, name, id').collect { |t| [t.latitude, t.longitude, t.name, t.id] }
  end

  def self.length_summary(area_ids)
    summary = {}
    area_ids.each do |area_id|
      find(:all, :conditions => ["area_id = ?", area_id], :select => 'condition_id, length').each do |track|
        if track.length > 0 and track.condition_id != nil
          summary[track.condition_id] = summary.has_key?(track.condition_id) ? summary[track.condition_id] + track.adjusted_length : track.adjusted_length
        end
      end
    end
    summary
  end

  def tweet_new
    tweet format_for_twitter("New track #{name} added to #{area.name}, #{area.region.name}.")
  end

  protected

  # Shoe-horn twitter message (some of), and track url
  def format_for_twitter(message)
    url = shorten_url "http://#{URL_BASE}/track/show/#{id}"
    message[0, 140 - 1 + url.length] + ' ' + url
  end

  def overview_is_not_empty
    errors.add_to_base("Overview cannot be empty.") if desc_overview.blank?
  end

  def fix_name
    fix_stupid_quotes!(name)
  end

  def name_is_unique_for_region
    if id.nil?
      existing = Track.find(:all, :conditions => ["name = ? AND area_id in (?)", name, area.region.areas.collect(&:id)], :select => 'name').size
    else
      existing = Track.find(:all, :conditions => ["id != ? AND name = ? AND area_id in (?)", id, name, area.region.areas.collect(&:id)], :select => 'name').size
    end
    errors.add(:name, "must be unique within #{area.region.name}") if existing != 0
  end
end
