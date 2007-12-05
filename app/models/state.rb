class State < ActiveRecord::Base
  has_many :areas
  belongs_to :nation
end
