class Setting < ActiveRecord::Base
  belongs_to :user
  belongs_to :map_type
  belongs_to :region
  
  before_validation_on_create :set_default_map_type

  VIDEO_VIEWER_SIZES = {"Small" => 160, "Medium" => 320, "Large" => 480};
  DEFAULT_VIDEO_VIEWER_SIZE = Setting::VIDEO_VIEWER_SIZES.values.max

  private
  
  def set_default_map_type
    self.map_type_id = MapType.default_map_type.id if map_type.nil?
  end
end
