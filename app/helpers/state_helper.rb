module StateHelper

  def get_area_markers(state_id)
    areas = []
    Area.find(:all, :conditions => ["state_id = ? AND zoom != 0", state_id], :select => 'latitude, longitude, name, id').each do |area|
      areas << [area.latitude, area.longitude, area.name, area.id]
    end
    areas
  end
end
