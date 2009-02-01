class RainReadingsController < ApplicationController

  before_filter :login_required, :only => [ :edit, :update, :new ]

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :index }

  def edit
    @rain_reading = RainReading.find(params[:id])
  end

  def update_rain
    @rain_reading = RainReading.find(params[:id])
    if !@rain_reading.update_attributes(params[:rain_reading])
      render :action => 'edit'
    end
  end

  def cancel_edit
    @rain_reading = RainReading.find(params[:id])
  end
end
