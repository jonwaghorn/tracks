class CreateTrackAkas < ActiveRecord::Migration
  def self.up
    create_table :track_akas do |t|
      t.column :track_id, :integer
      t.column :name, :string
    end
  end

  def self.down
    drop_table :track_akas
  end
end
