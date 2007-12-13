class CreateTrackAkas < ActiveRecord::Migration
  def self.up
    create_table :track_akas do |t|
      t.integer :track_id
      t.string  :name, :limit => 40, :default => "", :null => false
    end
  end

  def self.down
    drop_table :track_akas
  end
end
