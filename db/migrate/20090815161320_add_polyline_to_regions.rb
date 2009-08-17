class AddPolylineToRegions < ActiveRecord::Migration
  def self.up
    add_column :regions, :points, :text, :default => nil
    add_column :regions, :levels, :text
    add_column :regions, :num_levels, :integer
    add_column :regions, :zoom_factor, :integer
    add_column :regions, :colour, :integer, :default => 0
  end

  def self.down
    remove_column :regions, :points
    remove_column :regions, :levels
    remove_column :regions, :num_levels
    remove_column :regions, :zoom_factor
    remove_column :regions, :colour
  end
end
