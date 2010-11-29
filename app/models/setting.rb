# == Schema Information
# Schema version: 20090930170613
#
# Table name: settings
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)      not null
#  map_type_id :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#  region_id   :integer(4)      default(1)
#

class Setting < ActiveRecord::Base
  belongs_to :user
  belongs_to :map_type
  belongs_to :region
  
  before_validation_on_create :set_default_map_type

  DEFAULT_VIDEO_VIEWER_WIDTH = 480

  private
  
  def set_default_map_type
    self.map_type_id = MapType.default_map_type.id if map_type.nil?
  end
end
