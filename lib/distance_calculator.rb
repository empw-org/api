# frozen_string_literal: true

def degree_to_radian(value)
  value * Math::PI / 180
end

# calculates the distance between two coordinates in kilometers
class DistanceCalculator
  def self.between(point1, point2)
    earth_radius_km = 6371 # Earth radius in kilometers

    delta_lat_rad = degree_to_radian(point2[0] - point1[0]) # Delta, converted to rad
    delta_lon_rad = degree_to_radian(point2[1] - point1[1])

    lat1_rad, = point1.map { |i| degree_to_radian(i) }
    lat2_rad, = point2.map { |i| degree_to_radian(i) }

    a = Math.sin(delta_lat_rad / 2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(delta_lon_rad / 2)**2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    earth_radius_km * c # Delta in kilometers
  end
end
