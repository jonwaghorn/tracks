class StateRainReadingsController < ApplicationController
  include ApplicationHelper

  before_filter :login_required, :only => [ :edit, :update, :new ]

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :index }

  def edit
    @state_rain_reading = StateRainReading.find(params[:id])
  end

  def update_rain
    @state_rain_reading = StateRainReading.find(params[:id])
    if !@state_rain_reading.update_attributes(params[:state_rain_reading])
      render :action => 'edit'
    end
  end

  def cancel_edit
    @state_rain_reading = StateRainReading.find(params[:id])
  end
end
