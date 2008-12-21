class Area < ActiveRecord::Base
  include TextHelper

  belongs_to :state
  has_many :tracks, :order => 'name'

  before_validation       :fix_name

  validates_presence_of   :name
  validates_format_of     :name, :with => /^[\w ]+$/i, :message => 'can only contain letters and numbers (and spaces).'
  validates_length_of     :name, :maximum => 30, :message => 'Area name too long, maximum is 30 characters.'
  validates_uniqueness_of :name
  validates_presence_of   :description


  def self.get_markers(state_id)
    find(:all, :conditions => ["state_id = ? AND zoom != 0", state_id], :select => 'latitude, longitude, name, id').collect { |a| [a.latitude, a.longitude, a.name, a.id] }
  end

  private

  def fix_name
    fix_stupid_quotes!(name)
  end
end
