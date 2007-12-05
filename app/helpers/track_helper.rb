module TrackHelper
  
  def get_track_name(id)
    Track.find(id, :select => 'name').name
  end

  def get_track_id(name)
    Track.find(:first, :conditions => ["name = ?", name], :select => 'id').id
  end

  def track_length_summary(area_id)
    summary = {}
    Track.find(:all, :conditions => ["area_id = ?", area_id], :select => 'condition_id, length').each do |track|
      if track.length > 0 and track.condition_id != nil
        summary[track.condition_id] = summary.has_key?(track.condition_id) ? summary[track.condition_id] + track.length : track.length
      end
    end
    summary
  end
end
