class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.string   :name, :limit => 30, :default => "", :null => false
      t.integer  :nation_id
      t.datetime :date
      t.text     :description
      t.integer  :rain_readings, :default => 0
      t.decimal  :latitude, :precision =>9, :scale => 6, :default => 0
      t.decimal  :longitude, :precision =>9, :scale => 6, :default => 0
      t.integer  :zoom, :default => 0
    end
  end

  def self.down
    drop_table :states
  end
end
