class SearchController < ApplicationController

  # before_filter :login_required, :only => [ :edit, :update ]
  layout 'search'

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :index }

   def index
     @term = params[:search][:term] if params[:search] && params[:search][:term]
   end

end
