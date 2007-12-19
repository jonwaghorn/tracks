class Area < ActiveRecord::Base
  belongs_to :state
  has_many :tracks, :order => 'name'

  validates_presence_of   :name
  validates_format_of     :name, :with => /^[\w ]+$/i, :message => 'can only contain letters and numbers (and spaces).'
  validates_length_of     :name, :maximum => 30, :message => 'Area name too long, maximum is 30 characters.'
  validates_uniqueness_of :name
  validates_presence_of   :description
end
