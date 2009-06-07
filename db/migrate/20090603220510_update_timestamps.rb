class UpdateTimestamps < ActiveRecord::Migration
  def self.up
    add_column :tracks, :updated_at, :datetime
    rename_column :tracks, :date, :created_at
    Track.reset_column_information
    
    a = Area.new(:name => "temp", :region_id => 1, :description => "temp")
    a.id = 99
    a.save!
    Track.find(:all).each do |x|
      execute %{
        UPDATE tracks SET updated_at = "#{x.created_at.strftime('%Y-%m-%d %H:%M:%S')}" WHERE id = #{x.id}
      }
    end
    Area.delete(99)
    
    #---
    
    add_column :areas, :updated_at, :datetime
    rename_column :areas, :date, :created_at
    Area.reset_column_information
    Area.find(:all).each do |x|
      execute %{
        UPDATE areas SET updated_at = "#{x.created_at.strftime('%Y-%m-%d %H:%M:%S')}" WHERE id = #{x.id}
      }
    end
    
    #---
    
    add_column :regions, :updated_at, :datetime
    rename_column :regions, :date, :created_at
    Region.reset_column_information
    Region.find(:all).each do |x|
      execute %{
        UPDATE regions SET updated_at = "#{x.created_at.strftime('%Y-%m-%d %H:%M:%S')}" WHERE id = #{x.id}
      }
    end

    #---
    
    add_column :nations, :updated_at, :datetime
    rename_column :nations, :date, :created_at
    Nation.reset_column_information
    Nation.find(:all).each do |x|
      execute %{
        UPDATE nations SET updated_at = "#{x.created_at.strftime('%Y-%m-%d %H:%M:%S')}" WHERE id = #{x.id}
      }
    end
    
    #---
    
    add_column :track_reports, :updated_at, :datetime
    rename_column :track_reports, :date, :created_at
    TrackReport.reset_column_information
    TrackReport.find(:all).each do |x|
      execute %{
        UPDATE track_reports SET updated_at = "#{x.created_at.strftime('%Y-%m-%d %H:%M:%S')}" WHERE id = #{x.id}
      }
    end
    
  end

  def self.down
    remove_column :tracks, :updated_at
    rename_column :tracks, :created_at, :date
    
    remove_column :areas, :updated_at
    rename_column :areas, :created_at, :date
    
    remove_column :regions, :updated_at
    rename_column :regions, :created_at, :date
    
    remove_column :nations, :updated_at
    rename_column :nations, :created_at, :date
    
    remove_column :track_reports, :updated_at
    rename_column :track_reports, :created_at, :date
    
  end
end
