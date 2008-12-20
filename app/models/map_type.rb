class MapType < ActiveRecord::Base
  # has_many :settings

  DEFAULT_MAP_TYPE_ID = 2 # FIXME: hard-coded hackiness
  
  def self.default_map_type
    MapType.find(DEFAULT_MAP_TYPE_ID)
  end

end
