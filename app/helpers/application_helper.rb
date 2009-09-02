# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TextHelper
  # include GoogleVisualization

  SILLY_SALUTATIONS = [
    'sweet', 'sweet as', 'sweet as bro',
    'choice', 'choice bro', 'choice as',
    'nice', 'nice one', 'nice one bro', 'nice one Stu',
    'yeah', 'yeah baby', 'ooh yeah',
    'spot on'
    ]

  def silly_salutation
    SILLY_SALUTATIONS[rand(SILLY_SALUTATIONS.size)]
  end

  def user_map_style
    logged_in? ? current_user.setting.map_type.google_map_type : MapType.find(:first, :conditions => ['name = ?', 'Satellite']).google_map_type
  end

  # TODO allow for user-selectable units
  def distance(u)
    sprintf('%.2fkm', u)
  end

  # Request from an iPhone or iPod touch? (Mobile Safari user agent)
  def iphone_user_agent?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
    # true
  end
end

