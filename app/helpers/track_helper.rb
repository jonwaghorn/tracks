module TrackHelper

  def get_paths(track, path_type)
    return if track.g_map_tracks.empty?

    path = "prepareTrack();"
    track.g_map_tracks.each do |gmt|
      path += "trackData.push({" \
      "name: \"#{gmt.name.nil? ? track.name : gmt.name}\"," \
      "page: '/track/show/#{track.id}'," \
      "grade: '#{track.track_grade.name}'," \
      "length: '#{distance(track.length)}'," \
      "conditions: '#{track.condition.name}'," \
      "description: \"#{replace_for_view(h(track.desc_overview)).gsub(/"/,'\"')}\"," \
      "segmentType: '#{path_type}'," \
      "points: \"#{gmt.points}\"," \
      "levels: \"#{gmt.levels}\"," \
      "zoomFactor: #{gmt.zoom}," \
      "numLevels: #{gmt.num_levels}" \
      "});"
    end
    path + "processTrack();\n"
  end
end
