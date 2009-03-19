# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TextHelper

  SILLY_SALUTATION = [
    'sweet', 'sweet as', 'sweet as bro',
    'choice', 'choice bro', 'choice as',
    'nice', 'nice one', 'nice one bro', 'nice one Stu',
    'yeah', 'yeah baby', 'ooh yeah',
    'spot on'
    ]

  def silly_salutation
    SILLY_SALUTATION[rand(SILLY_SALUTATION.size)]
  end

  def user_map_style
    logged_in? ? current_user.setting.map_type.google_map_type : MapType.find(:first, :conditions => ['name = ?', 'Satellite']).google_map_type
  end

  def distance(u)
    sprintf('%.2fkm', u)
  end

end

