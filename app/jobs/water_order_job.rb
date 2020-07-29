# frozen_string_literal: true

class WaterOrderJob < ApplicationJob
  queue_as :water_orders
  attr_reader :water_order

  before_perform do |job|
    id = job.arguments.first
    @water_order = WaterOrder.find(id)
  end

  class Pending < WaterOrderJob
    def perform(_id)
      nearest_company = Company.where(maintenance: false)
                               .near_sphere(location: @water_order.location)
                               .limit(1).first
      if nearest_company.nil?
        WaterOrderJob::Pending.set(wait_until: Date.tomorrow).perform_later(@water_order.id.to_s)
      else
        @water_order.update(company: nearest_company, state: WaterOrder::ASSIGNED_TO_COMPANY)
      end
    end
  end

  class ReadyForShipping < WaterOrderJob
    def perform(*args); end
  end
end
