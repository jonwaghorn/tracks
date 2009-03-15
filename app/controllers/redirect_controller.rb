class RedirectController < ApplicationController
   def index
     headers["Status"] = "301 Moved Permanently"
     redirect_to "http://tracks.org.nz"
   end
end
