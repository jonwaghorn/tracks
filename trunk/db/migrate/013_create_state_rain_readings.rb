class CreateStateRainReadings < ActiveRecord::Migration
  def self.up
    create_table :state_rain_readings do |t|
      t.integer  :state_id
      t.decimal  :mm, :precision =>4, :scale => 1, :default => -1.0
      t.datetime :date
    end
  end

  def self.down
    drop_table :state_rain_readings
  end
end
