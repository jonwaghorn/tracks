class Region < ActiveRecord::Base

  include TwitterHelper
  include TextHelper

  has_many :areas, :order => 'name'
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
    tweet format_for_twitter("new region #{name} added.")
  end

  # Shoe-horn twitter message (some of), and region url
  def format_for_twitter(message)
    url = shorten_url "http://#{URL_BASE}/region/show/#{id}"
    message[0, 140 - 1 + url.length] + ' ' + url
  end

  private

    def fix_name
      fix_stupid_quotes!(name)
    end
end
