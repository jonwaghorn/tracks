class CreateNations < ActiveRecord::Migration
  def self.up
    create_table :nations do |t|
      t.string   :name, :limit => 30, :default => "", :null => false
      t.text     :description, :default => ""
      t.datetime :date
    end

    add_index :nations, :name, :unique => true
  end

  def self.down
    remove_index :nations, :name
    drop_table :nations
  end
end
