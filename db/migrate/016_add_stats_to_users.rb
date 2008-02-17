class AddStatsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :edits, :integer, :default => 0
    add_column :users, :reports, :integer, :default => 0
    add_column :users, :last_track_edit_at, :datetime
    User.reset_column_information
  end

  def self.down
    remove_column :users, :edits
    remove_column :users, :reports
    remove_column :users, :last_track_edit_at
  end
end
