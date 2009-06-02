class AddNameToGMapTrack < ActiveRecord::Migration
  def self.up
    add_column :g_map_tracks, :name, :string
  end

  def self.down
    remove_column :g_map_tracks, :name
  end
end
