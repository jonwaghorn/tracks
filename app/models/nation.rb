class Nation < ActiveRecord::Base
  has_many :regions, :order => 'sequence, name'

  validates_presence_of   :name
  validates_format_of     :name, :with => /^[\w ]+$/i, :message => 'can only contain letters and numbers (and spaces).'
  validates_length_of     :name, :maximum => 30, :message => 'Nation name too long, maximum is 30 characters.'
  validates_uniqueness_of :name
  validates_presence_of   :description

  # Update the region sequence based on the region ids in new_order
  def save_region_order(new_order)
    new_order.each_with_index do |region_id, i|
      region = Region.find(region_id)
      region.sequence = i+1
      region.save!
    end
  end

end
