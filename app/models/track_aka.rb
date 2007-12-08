class TrackAka < ActiveRecord::Base
  has_one :track

  validates_presence_of   :name
  validates_format_of     :name, :with => /^\w+$/i, :message => 'can only contain letters and numbers.'
  validates_length_of     :name, :maximum => 30, :message => '\'Also known as\' name too long, maximum is 30 characters.'
  validates_uniqueness_of :name
end
