class CreateTrackConnections < ActiveRecord::Migration
  def self.up
    create_table :track_connections do |t|
      t.integer :track_id
      t.integer :connect_track_id
    end
  end

  def self.down
    drop_table :track_connections
  end
end
