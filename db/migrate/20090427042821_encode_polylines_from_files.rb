class EncodePolylinesFromFiles < ActiveRecord::Migration
  def self.up
    require 'hpricot'

    Track.find(:all).each do |track|
      # puts "###### Processing track #{track.name} (#{track.id})"
      begin
        track.process_kml_path(open("public/paths/#{track.id}.kml") { |f| Hpricot(f) })
      rescue Errno::ENOENT
        puts "Missing path data for track #{track.name} (#{track.id})"
        next
      end
    end
  end

  def self.down
    GMapTrack.delete_all
  end
end
