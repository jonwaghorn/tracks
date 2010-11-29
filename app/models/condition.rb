# == Schema Information
# Schema version: 20090930170613
#
# Table name: conditions
#
#  id   :integer(4)      not null, primary key
#  name :string(255)
#

class Condition < ActiveRecord::Base
  has_one :track
end
