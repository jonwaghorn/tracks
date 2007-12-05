class Area < ActiveRecord::Base
  belongs_to :state
  has_many :tracks
end
