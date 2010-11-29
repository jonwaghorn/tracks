# == Schema Information
# Schema version: 20090930170613
#
# Table name: track_accesses
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :text
#

class TrackAccess < ActiveRecord::Base
  has_one :track
end
