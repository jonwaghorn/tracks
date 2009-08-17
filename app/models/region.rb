class Region < ActiveRecord::Base
  
  require 'gmap_polyline_encoder'

  include TwitterHelper
  include TextHelper

  has_many :areas, :order => 'name'
  has_many :tracks, :through => :areas
  belongs_to :nation
  has_many :settings

  before_validation       :fix_name

  validates_presence_of     :name
  validates_format_of       :name, :with => /^[\w ]+$/i, :message => 'can only contain letters and numbers (and spaces).'
  validates_length_of       :name, :maximum => 30, :message => 'Region name too long, maximum is 30 characters.'
  validates_uniqueness_of   :name
  validates_presence_of     :description
  validates_presence_of     :rain_readings
  validates_inclusion_of    :rain_readings, :in => 0..21, :message => 'must be in the range 0-21 (inclusive).'

  # COLOURS = ['#ff0000','#00ff00','#0000ff','#ffff00','#ff00ff','#00ffff']
  COLOURS = ['#fd5f5f','#24b4ff','#c0ff00','#ffc600']

  def tweet_new
    tweet format_for_twitter("New region #{name} added.")
  end

  def tracks_summary
    summary = []
    tracks.group_by(&:condition_id).each { |a| summary << [Condition.find(a[0]).name.to_s, a[1].collect(&:adjusted_length).sum] unless a[0].nil? }
    summary.sort_by {|a| a[1]}.reverse
  end

  def encode_region_area(coords)
    data = []
    coords.split(';').each do |latlng|
      lat,lng = latlng.split(',')
      data << [lat.to_f,lng.to_f]
      # puts "#{data.inspect}"
    end

    encoder = GMapPolylineEncoder.new()
    result = encoder.encode(data)
# puts result.inspect

    self.points = result[:points]
    self.levels = result[:levels]
    self.num_levels = result[:numLevels]
    self.zoom_factor = result[:zoomFactor]
  end

  def get_encoded_region
    "polylines: [" \
    "{points: \"#{points}\"," \
    "levels: \"#{levels}\"," \
    "color: \"#{get_colour}\"," \
    "opacity: 0.7," \
    "weight: 2," \
    "numLevels: #{num_levels}," \
    "zoomFactor: #{zoom_factor}}]"
  end

  def get_colour
    COLOURS[colour]
  end

  protected

  # Shoe-horn twitter message (some of), and region url
  def format_for_twitter(message)
    url = shorten_url "http://#{URL_BASE}/region/show/#{id}"
    message[0, 140 - 1 + url.length] + ' ' + url
  end

  def fix_name
    fix_stupid_quotes!(name)
  end
end
