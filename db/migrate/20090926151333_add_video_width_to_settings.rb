class AddVideoWidthToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :video_width, :integer, :default => 480
  end

  def self.down
    remove_column :settings, :video_width
  end
end
