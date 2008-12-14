module AreaHelper

  def get_track_markers(area_id)
    tracks = []
    Track.find(:all, :conditions => ["area_id = ? AND zoom != 0", area_id], :select => 'latitude, longitude, name, id').each do |track|
      tracks << [track.latitude, track.longitude, track.name, track.id]
    end
    tracks
  end
end
