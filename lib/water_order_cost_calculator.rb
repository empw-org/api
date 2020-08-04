# frozen_string_literal: true

COST_PER_KILOMETER = 1.15
COST_PER_LITRE = 2.75
EMPW_BENEFIT_PERCENTAGE = 5 / 100.0

class WaterOrderCostCalculator
  def self.calc(water_order)
    distance = water_order.distance
    delivery_cost = (distance * COST_PER_KILOMETER).ceil
    water_cost = (water_order.amount * COST_PER_LITRE).ceil
    cost = delivery_cost + water_cost
    empw_benefit = (cost * EMPW_BENEFIT_PERCENTAGE).ceil
    total_cost = empw_benefit + cost
    { total_cost: total_cost, delivery_cost: delivery_cost, empw_benefit: empw_benefit, water_cost: water_cost }
  end
end
