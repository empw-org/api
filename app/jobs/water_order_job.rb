class WaterOrderJob < ApplicationJob
  queue_as :water_orders
  attr_reader :water_order

  before_perform do |job|
    puts 'Setting water order for id'
    id = job.arguments.first
    @water_order = WaterOrder.find(id)
  end

  class Pending < WaterOrderJob
    def perform(id)
      puts 'A Pending Water Order'
      nearest_company = Company
                        .near_sphere(location: @water_order.location)
                        .limit(1).to_a.first
      @water_order.update(company: nearest_company,
                          state: WaterOrder::ASSIGNED_TO_COMPANY)
      puts 'assigned to company'
      pp @water_order.company
    end
  end

  class ReadyForShipping < WaterOrderJob
    def perform(*args)
      puts 'A ReadyForShipping Water Order'
      pp args
    end
  end
end
