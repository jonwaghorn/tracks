class AddProgressToFeature < ActiveRecord::Migration
  def self.up
    add_column :features, :progress, :string
  end

  def self.down
    remove_column :features, :progress
  end
end
