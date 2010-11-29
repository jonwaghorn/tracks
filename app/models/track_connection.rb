# == Schema Information
# Schema version: 20090930170613
#
# Table name: track_connections
#
#  id               :integer(4)      not null, primary key
#  track_id         :integer(4)
#  connect_track_id :integer(4)
#

class TrackConnection < ActiveRecord::Base
  belongs_to :track
end
