module NationHelper
  
  def get_nation_name(id)
    Nation.find(id, :select => 'name').name
  end

  def get_nation_id(name)
    Nation.find(:first, :conditions => ["name = ?", name], :select => 'id').id
  end
end
