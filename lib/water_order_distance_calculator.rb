# frozen_string_literal: true

# calculates the distance between water_order location and company location
class WaterOrderDistanceCalculator
  def self.calc(water_order)
    DistanceCalculator.between(water_order.location, water_order.company.location)
  end
end
