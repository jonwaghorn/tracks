# == Schema Information
# Schema version: 20090930170613
#
# Table name: track_akas
#
#  id       :integer(4)      not null, primary key
#  track_id :integer(4)
#  name     :string(40)      default(""), not null
#

class TrackAka < ActiveRecord::Base
  belongs_to :track

  validates_presence_of   :name
  validates_format_of     :name, :with => /^[\w ']+$/i, :message => 'can only contain letters and numbers (and spaces).'
  validates_length_of     :name, :maximum => 30, :message => '\'Also known as\' name too long, maximum is 30 characters.'
  validates_uniqueness_of :name
end
