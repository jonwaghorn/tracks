class State < ActiveRecord::Base
  include TextHelper

  has_many :areas, :order => 'name'
  belongs_to :nation

  before_validation       :fix_name

  validates_presence_of     :name
  validates_format_of       :name, :with => /^[\w ]+$/i, :message => 'can only contain letters and numbers (and spaces).'
  validates_length_of       :name, :maximum => 30, :message => 'State name too long, maximum is 30 characters.'
  validates_uniqueness_of   :name
  validates_presence_of     :description
  validates_presence_of     :rain_readings
  validates_inclusion_of    :rain_readings, :in => 0..21, :message => 'must be in the range 0-21 (inclusive).'

  private

    def fix_name
      fix_stupid_quotes!(name)
    end
end
