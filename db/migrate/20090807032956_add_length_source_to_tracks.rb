class AddLengthSourceToTracks < ActiveRecord::Migration
  def self.up

    require 'hpricot'

    ActiveRecord::Base.record_timestamps = false

    add_column :tracks, :length_source, :string
    add_column :tracks, :length_adjust_percent, :integer, :default => 0
    change_column :tracks, :length, :decimal, :precision => 6, :scale => 3, :default => 0.0
    
    Track.reset_column_information
    
    a = Area.new(:name => "temp", :region_id => 1, :description => "temp")
    a.id = 99
    a.save!

    Track.find(:all).each do |track|
      puts "###### Processing track #{track.name} (#{track.id})"
      puts "  old length = #{track.length}"
      track.length_source = 'user' if track.length != 0
      begin
        track.process_kml_path(open("public/paths/#{track.id}.kml") { |f| Hpricot(f) }) # saves
        puts "  new length = #{track.length}"
      rescue Errno::ENOENT
        puts "Missing path data for track #{track.name} (#{track.id})"
        track.save!
        next
      end
    end

    Area.delete(99)

  end

  def self.down
    remove_column :tracks, :length_source
    remove_column :tracks, :length_adjust_percent
    change_column :tracks, :length, :decimal, :precision => 5, :scale => 2, :default => 0.0
  end
end
