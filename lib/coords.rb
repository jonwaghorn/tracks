module Coords

  # haversine formula to compute the great circle distance between two points given their latitude and longitudes
  #
  # Copyright (C) 2008, 360VL, Inc
  # Copyright (C) 2008, Landon Cox
  #
  # http://www.360vl.com (360VL, Inc.)
  # http://sawdust.see-do.org (Landon Cox)
  #
  # LICENSE: GNU Affero GPL v3
  # The ruby implementation of the Haversine formula is free software: you can redistribute it and/or modify
  # it under the terms of the GNU Affero General Public License version 3 as published by the Free Software Foundation.  
  #
  # This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the 
  # implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public 
  # License version 3 for more details.  http://www.gnu.org/licenses/
  #
  # Landon Cox - 9/25/08
  # Jon Waghorn - 8/6/09 simplified for metres only
  # 
  # Notes:
  # translated into Ruby based on information contained in:
  #   http://mathforum.org/library/drmath/view/51879.html  Doctors Rick and Peterson - 4/20/99
  #   http://www.movable-type.co.uk/scripts/latlong.html
  #   http://en.wikipedia.org/wiki/Haversine_formula
  #
  # This formula can compute accurate distances between two points given latitude and longitude, even for 
  # short distances.

  RAD_PER_DEG = 0.017453293  #  PI/180

  Rkm = 6371              # radius of the great circle in kilometers...some algorithms use 6367
  Rmeters = Rkm * 1000    # radius in meters

  def haversine_distance(lat1, lon1, lat2, lon2)
    dlon = lon2 - lon1
    dlat = lat2 - lat1

    dlon_rad = dlon * RAD_PER_DEG 
    dlat_rad = dlat * RAD_PER_DEG

    lat1_rad = lat1 * RAD_PER_DEG
    lon1_rad = lon1 * RAD_PER_DEG

    lat2_rad = lat2 * RAD_PER_DEG
    lon2_rad = lon2 * RAD_PER_DEG

    a = (Math.sin(dlat_rad/2))**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * (Math.sin(dlon_rad/2))**2
    c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a))

    Rmeters * c     # delta in meters
  end

  # Parse lat lng data and calculate the full length of the path
  def calculate_path_length(latlng_data)
    return nil if (latlng_data.nil? or latlng_data.empty?)
    return 0 if latlng_data.length < 2
    lat,lng = latlng_data.first
    t_length = 0.0
    latlng_data.each do |latlng|
      t_length += haversine_distance(lat, lng, latlng.first, latlng.last)
      lat,lng = latlng
    end
    t_length
  end
end
