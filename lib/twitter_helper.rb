module TwitterHelper

  require 'shorturl'
  require 'twitter'

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