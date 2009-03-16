class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :feature_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
