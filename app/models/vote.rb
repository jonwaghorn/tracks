class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :feature
  
  MAX_VOTES_PER_USER = 3

  def self.total_by(feature, user)
    find(:all, :conditions => ["user_id = ? AND feature_id = ?", user.id, feature.id])
  end
end
