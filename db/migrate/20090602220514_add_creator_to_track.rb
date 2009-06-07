class AddCreatorToTrack < ActiveRecord::Migration
  def self.up
    add_column :tracks, :created_by, :integer
    rename_column :tracks, :author, :updated_by

    Track.reset_column_information
    
    a = Area.new(:name => "temp", :region_id => 1, :description => "temp")
    a.id = 99
    a.save!

    Track.find(:all).each do |t|
      t.created_by = t.updated_by
      t.created_by = 1 if t.id < 74
      t.save!
    end

    Area.delete(99)

  end

  def self.down
    remove_column :tracks, :created_by
    rename_column :tracks, :updated_by, :author
  end
end
