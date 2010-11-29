# == Schema Information
# Schema version: 20090930170613
#
# Table name: areas
#
#  id          :integer(4)      not null, primary key
#  name        :string(30)      default(""), not null
#  region_id   :integer(4)
#  created_at  :datetime
#  description :text
#  latitude    :decimal(9, 6)   default(0.0)
#  longitude   :decimal(9, 6)   default(0.0)
#  zoom        :integer(4)      default(0)
#  updated_at  :datetime
#

class Area < ActiveRecord::Base

  include TwitterHelper
  include TextHelper

  belongs_to :region
  has_many :tracks, :order => 'name'

  before_validation       :fix_name

  validates_presence_of   :name
  validates_format_of     :name, :with => /^[\w ]+$/i, :message => 'can only contain letters and numbers (and spaces).'
  validates_length_of     :name, :maximum => 30, :message => 'Area name too long, maximum is 30 characters.'
  validates_uniqueness_of :name
  validates_presence_of   :description


  def self.get_markers(region_id)
    find(:all, :conditions => ["region_id = ? AND zoom != 0", region_id], :select => 'latitude, longitude, name, id').collect { |a| [a.latitude, a.longitude, a.name, a.id] }
  end

  def tweet_new
    tweet format_for_twitter("New area #{name} added to #{region.name}.")
  end

  def tracks_summary
    summary = []
    tracks.group_by(&:condition_id).each { |a| summary << [Condition.find(a[0]).name.to_s, a[1].collect(&:adjusted_length).sum] unless a[0].nil? }
    summary.sort_by {|a| a[1]}.reverse
  end

  protected

  # Shoe-horn twitter message (some of), and area url
  def format_for_twitter(message)
    url = shorten_url "http://#{URL_BASE}/area/show/#{id}"
    message[0, 140 - 1 + url.length] + ' ' + url
  end

  def fix_name
    fix_stupid_quotes!(name)
  end
end
