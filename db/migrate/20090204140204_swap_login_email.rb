class SwapLoginEmail < ActiveRecord::Migration
  def self.up
    rename_column :users, :login, :screen_name
    rename_column :users, :email, :login
  end

  def self.down
    rename_column :users, :login, :email
    rename_column :users, :screen_name, :login
  end
end
