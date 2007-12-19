class AddPrivilegeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :privilege, :string, :limit => 20, :default => 'viewer'
    User.reset_column_information
    # User privileges
    #   admin
    #   creator
    #   editor
    #   viewer
  end

  def self.down
    remove_column :users, :privilege
  end
end
