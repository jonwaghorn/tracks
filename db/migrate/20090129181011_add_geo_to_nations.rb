class AddGeoToNations < ActiveRecord::Migration
  def self.up
    add_column :nations, :latitude, :decimal, :precision => 9, :scale => 6, :default => 0
    add_column :nations, :longitude, :decimal, :precision => 9, :scale => 6, :default => 0
    add_column :nations, :zoom, :integer, :default => 0
    Nation.reset_column_information
    Nation.update_all(:latitude => -40.913512, :longitude => 172.705078, :zoom => 5)
  end

  def self.down
    remove_column :nations, :latitude
    remove_column :nations, :longitude
    remove_column :nations, :zoom
  end
end
