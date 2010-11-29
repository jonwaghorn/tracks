# == Schema Information
# Schema version: 20090930170613
#
# Table name: map_types
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  google_map_type :string(255)
#

class MapType < ActiveRecord::Base
  # has_many :settings

  DEFAULT_MAP_TYPE_ID = 2 # FIXME: hard-coded hackiness
  
  def self.default_map_type
    MapType.find(DEFAULT_MAP_TYPE_ID)
  end

end
