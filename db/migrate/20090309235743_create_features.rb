class CreateFeatures < ActiveRecord::Migration
  def self.up
    create_table :features do |t|
      t.string :kind
      t.string :title
      t.text :description
      t.integer :user_id
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :features
  end
end
