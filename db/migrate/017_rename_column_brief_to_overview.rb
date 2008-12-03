class RenameColumnBriefToOverview < ActiveRecord::Migration
  def self.up
    rename_column :tracks, :desc_brief, :desc_overview
  end

  def self.down
    rename_column :tracks, :desc_overview, :desc_brief
  end
end
