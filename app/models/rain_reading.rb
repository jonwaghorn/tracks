# == Schema Information
# Schema version: 20090930170613
#
# Table name: rain_readings
#
#  id        :integer(4)      not null, primary key
#  region_id :integer(4)
#  mm        :decimal(4, 1)   default(-1.0)
#  date      :datetime
#

class RainReading < ActiveRecord::Base
end
