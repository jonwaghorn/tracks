class Nation < ActiveRecord::Base
  has_many :regions, :order => 'sequence, name'

  validates_presence_of   :name
  validates_format_of     :name, :with => /^[\w ]+$/i, :message => 'can only contain letters and numbers (and spaces).'
  validates_length_of     :name, :maximum => 30, :message => 'Nation name too long, maximum is 30 characters.'
  validates_uniqueness_of :name
  validates_presence_of   :description

  def region_up(i)
    return if i <= 0
    reset_region_order
    regions[i - 1].sequence += 1
    regions[i].sequence -= 1
    regions[i-1].save!
    regions[i].save!
  end

  def region_down(i)
    return if (i+1) >= regions.length
    reset_region_order
    regions[i + 1].sequence -= 1
    regions[i].sequence += 1
    regions[i+1].save!
    regions[i].save!
  end
  
  protected
  
  # These things can get out of whack, edge case and infrequently used
  # Doesn't matter about inefficiency...
  def reset_region_order
    # get the default order and re-apply the sequence
    regions.each_with_index do |r,i|
      r.sequence = i
      r.save!
    end
  end
end
