class WaterOrderJob < ApplicationJob
  queue_as :water_orders
  attr_reader :water_order

  before_perform do |job|
    id = job.arguments.first
    @water_order = WaterOrder.find(id)
  end

  class Pending < WaterOrderJob
    def perform(_id)
      nearest_company = Company
                        .near_sphere(location: @water_order.location)
                        .limit(1).to_a.first
      @water_order.update(company: nearest_company,
                          state: WaterOrder::ASSIGNED_TO_COMPANY)
    end
  end

  class ReadyForShipping < WaterOrderJob
    def perform(*args)
    end
  end
end
