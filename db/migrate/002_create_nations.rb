class CreateNations < ActiveRecord::Migration
  def self.up
    create_table :nations do |t|
      t.column :name, :string, :limit => 40, :default => "", :null => false
      t.column :description, :string, :default => ""
      t.column :date, :datetime
    end
    add_index :nations, :name, :unique => true
  end

  def self.down
    remove_index :nations, :name
    drop_table :nations
  end
end
