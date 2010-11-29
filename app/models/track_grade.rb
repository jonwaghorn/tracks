# == Schema Information
# Schema version: 20090930170613
#
# Table name: track_grades
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :text
#

class TrackGrade < ActiveRecord::Base
  has_one :track
end
