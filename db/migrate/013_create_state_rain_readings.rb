class CreateStateRainReadings < ActiveRecord::Migration
  def self.up
    create_table :state_rain_readings do |t|
      t.column :state_id, :integer
      t.column :mm, :decimal, :precision =>4, :scale => 1, :default => -1.0
      t.column :date, :datetime
    end
  end

  def self.down
    drop_table :state_rain_readings
  end
end
