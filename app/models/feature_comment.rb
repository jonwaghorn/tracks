# == Schema Information
# Schema version: 20090930170613
#
# Table name: feature_comments
#
#  id         :integer(4)      not null, primary key
#  feature_id :integer(4)
#  user_id    :integer(4)
#  comment    :text
#  created_at :datetime
#  updated_at :datetime
#

class FeatureComment < ActiveRecord::Base
  belongs_to :feature
  belongs_to :feature_comment
  belongs_to :user
end
