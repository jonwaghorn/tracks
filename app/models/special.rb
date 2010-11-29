# == Schema Information
# Schema version: 20090930170613
#
# Table name: specials
#
#  id      :integer(4)      not null, primary key
#  name    :string(255)
#  content :text
#

class Special < ActiveRecord::Base
end
