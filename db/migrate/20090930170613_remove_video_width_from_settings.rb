class RemoveVideoWidthFromSettings < ActiveRecord::Migration
  def self.up
    remove_column :settings, :video_width
  end

  def self.down
    add_column :settings, :video_width, :integer, :default => 480
  end
end
