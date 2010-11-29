# == Schema Information
# Schema version: 20090930170613
#
# Table name: votes
#
#  id         :integer(4)      not null, primary key
#  feature_id :integer(4)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :feature
  
  MAX_VOTES_PER_USER = 3

  def self.total_by(feature, user)
    find(:all, :conditions => ["user_id = ? AND feature_id = ?", user.id, feature.id])
  end
end
