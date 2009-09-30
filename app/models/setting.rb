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
