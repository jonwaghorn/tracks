module StateHelper
  
  def get_state_name(id)
    State.find(id, :select => 'name').name
  end

  def get_state_id(name)
    State.find(:first, :conditions => ["name = ?", name], :select => 'id').id
  end

  def get_area_markers(state_id)
    areas = []
    Area.find(:all, :conditions => ["state_id = ? AND zoom != 0", state_id], :select => 'latitude, longitude, name, id').each do |area|
      areas << [area.latitude, area.longitude, area.name, area.id]
    end
    areas
  end
end
