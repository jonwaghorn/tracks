class CreateAreas < ActiveRecord::Migration
  def self.up
    create_table :areas do |t|
      t.column :name, :string, :limit => 30, :default => "", :null => false
      t.column :state_id, :integer
      t.column :date, :datetime
      t.column :description, :string
      t.column :latitude, :decimal, :precision =>9, :scale => 6, :default => 0
      t.column :longitude, :decimal, :precision =>9, :scale => 6, :default => 0
      t.column :zoom, :integer, :default => 0
    end
  end

  def self.down
    drop_table :areas
  end
end
