# == Schema Information
# Schema version: 20090930170613
#
# Table name: g_map_tracks
#
#  id         :integer(4)      not null, primary key
#  track_id   :integer(4)
#  sequence   :integer(4)
#  points     :text
#  levels     :text
#  zoom       :integer(4)
#  num_levels :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  name       :string(255)
#

class GMapTrack < ActiveRecord::Base
  belongs_to :track
end
