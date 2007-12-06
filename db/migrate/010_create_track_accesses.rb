class CreateTrackAccesses < ActiveRecord::Migration
  def self.up
    create_table :track_accesses do |t|
      t.column :name, :string
      t.column :description, :string
    end
    
    TrackAccess.create :name => 'Bike and Foot', :description => 'Track is open for shared use.'
    TrackAccess.create :name => 'Foot', :description => 'Unless stated otherwise, these tracks are closed to cyclists.'
    TrackAccess.create :name => 'Bike', :description => 'Bicycles allowed.'
    TrackAccess.create :name => 'Private', :description => 'Permission is required, check access notes.'
    TrackAccess.create :name => 'Seasonal', :description => 'Access is on a seasonal basis, usually due to track conditions or farm activity. Check the access notes.'
    TrackAccess.create :name => 'Closed', :description => 'No access for anyone. Entering this area may harm future access, only enter with permission.'
    TrackAccess.create :name => 'Under construction', :description => 'Generally no acces because you either can\'t get through or track builders do not want you there. Check the access notes, you may be able to help build the track!'

    remove_column :tracks, :status
    add_column :tracks, :track_access_id, :integer
    rename_column :tracks, :status_note, :access_note
  end

  def self.down
    drop_table :track_accesses

    remove_column :tracks, :track_access_id
    add_column :tracks, :status, :string
    rename_column :tracks, :access_note, :status_note
  end
end
