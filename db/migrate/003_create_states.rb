class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.column :name, :string, :limit => 40, :default => "", :null => false
      t.column :nation_id, :integer
      t.column :date, :datetime
      t.column :description, :string
      t.column :rain_readings, :integer
      t.column :latitude, :decimal, :precision =>9, :scale => 6, :default => 0
      t.column :longitude, :decimal, :precision =>9, :scale => 6, :default => 0
      t.column :zoom, :integer, :default => 0
    end
  end

  def self.down
    drop_table :states
  end
end
