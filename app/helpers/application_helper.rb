# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TextHelper

  def map_type_options
    MapType.find(:all).collect { |mt| [mt.name, mt.id] }
  end

  def user_map_style
    logged_in? ? current_user.setting.map_type.google_map_type : MapType.find(:first, :conditions => ['name = ?', 'Satellite']).google_map_type
  end

  def distance(u)
    u.to_s + 'km'
  end

end

