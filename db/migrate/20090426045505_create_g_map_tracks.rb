class CreateGMapTracks < ActiveRecord::Migration
  def self.up
    create_table :g_map_tracks do |t|
      t.integer :track_id
      t.integer :sequence
      t.text :points
      t.text :levels
      t.integer :zoom
      t.integer :num_levels

      t.timestamps
    end
  end

  def self.down
    drop_table :g_map_tracks
  end
end
