# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :check_uri

  helper :all # include all helpers, all the time
  include AuthenticatedSystem
  include UserStats
  include TextHelper
  include TwitterHelper

  before_filter :login_from_cookie

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '9b0b65664c7da55cd404ec896c0fd339'

  def check_uri
    redirect_to request.protocol + request.host_with_port[4..-1] + request.request_uri if /^www/.match(request.host)
  end
end
