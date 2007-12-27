class RemoveTrackReportStatus < ActiveRecord::Migration
  def self.up
    remove_column :track_reports, :status
  end

  def self.down
    add_column :track_reports, :status, :string, :default => 'Green'
  end
end
