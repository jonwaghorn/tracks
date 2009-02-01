class UpdateSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :state_id, :integer, :default => 1 # This is Wellington
    Setting.reset_column_information
  end

  def self.down
    remove_column :settings, :state_id
  end
end
