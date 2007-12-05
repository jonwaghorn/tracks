class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.column :name, :string
      t.column :description, :string
    end
    
    Status.create :name => 'Bike and Foot', :description => 'Track is open for shared use.'
    Status.create :name => 'Foot', :description => 'Unless stated otherwise, these tracks are closed to cyclists.'
    Status.create :name => 'Bike', :description => 'Bicycles allowed.'
    Status.create :name => 'Private', :description => 'Permission is required, check access notes.'
    Status.create :name => 'Seasonal', :description => 'Access is on a seasonal basis, usually due to track conditions or farm activity. Check the access notes.'
    Status.create :name => 'Closed', :description => 'No access for anyone. Entering this area may harm future access, only enter with permission.'
    Status.create :name => 'Under construction', :description => 'Generally no acces because you either can\'t get through or track builders do not want you there. Check the access notes, you may be able to help build the track!'

    remove_column :tracks, :status
    add_column :tracks, :status_id, :integer
  end

  def self.down
    drop_table :statuses

    remove_column :tracks, :status_id
    add_column :tracks, :status, :string
  end
end
