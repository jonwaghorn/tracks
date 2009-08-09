class Region < ActiveRecord::Base

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

  def tweet_new
    tweet format_for_twitter("New region #{name} added.")
  end

  def tracks_summary
    summary = []
    tracks.group_by(&:condition_id).each { |a| summary << [Condition.find(a[0]).name.to_s, a[1].collect(&:adjusted_length).sum] unless a[0].nil? }
    summary.sort_by {|a| a[1]}.reverse
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
