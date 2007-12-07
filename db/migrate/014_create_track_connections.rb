class CreateTrackConnections < ActiveRecord::Migration
  def self.up
    create_table :track_connections do |t|
      t.column :track_id, :integer
      t.column :connect_track_id, :integer
    end
  end

  def self.down
    drop_table :track_connections
  end
end
