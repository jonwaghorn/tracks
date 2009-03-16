class CreateFeatureComments < ActiveRecord::Migration
  def self.up
    create_table :feature_comments do |t|
      t.integer :feature_id
      t.integer :user_id
      t.string :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :feature_comments
  end
end
