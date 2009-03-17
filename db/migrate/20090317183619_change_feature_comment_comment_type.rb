class ChangeFeatureCommentCommentType < ActiveRecord::Migration
  def self.up
    change_column :feature_comments, :comment, :text
  end

  def self.down
    change_column :feature_comments, :comment, :string
  end
end
