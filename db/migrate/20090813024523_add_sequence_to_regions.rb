class AddSequenceToRegions < ActiveRecord::Migration
  def self.up
    add_column :regions, :sequence, :integer, :default => -1
    n = Nation.find(1)
    n.regions.each_with_index do |region,i|
      region.sequence = i
      region.save!
    end
  end

  def self.down
    remove_column :regions, :sequence
  end
end
