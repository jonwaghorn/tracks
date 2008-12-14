# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  require 'shorturl'
  require 'twitter'

  helper :all # include all helpers, all the time
  include AuthenticatedSystem
  include UserStats
  include TextHelper

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '9b0b65664c7da55cd404ec896c0fd339'

  # Send _message_ to Twitter
  def tweet(message)
    logger.info "Tweeting message: #{message}"
    begin
      Twitter::Client.new(:login => 'tracks_org_nz', :password => 'zaq12WSX').status(:post, message) if RAILS_ENV == "production"
    rescue
      logger.warn "Failed to tweet"
    end
  end

  # Attempt to shorten _long_url_, returns original url if shortening fails or there is a problem
  def shorten_url(long_url)
    begin
      short_url = ShortURL.shorten(long_url)
    rescue
      short_url = nil
    end
    short_url.nil? ? long_url : short_url
  end

end
