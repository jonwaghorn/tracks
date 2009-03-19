class FeatureComment < ActiveRecord::Base
  belongs_to :feature
  belongs_to :feature_comment
  belongs_to :user
end
