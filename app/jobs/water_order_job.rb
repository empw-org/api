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
        @water_order.company = nearest_company
        @water_order.state = WaterOrder::ASSIGNED_TO_COMPANY
        @water_order.distance = WaterOrderDistanceCalculator.calc(@water_order)
        @water_order.cost = WaterOrderCostCalculator.calc(@water_order)
        @water_order.save
      end
    end
  end

  class ReadyForShipping < WaterOrderJob
    def perform(_id)
      puts 'READY-FOR-SHIPPING'
      ActionCable.server.broadcast('transporters',
                                   { type: 'water_order', data: @water_order })
    end
  end

  class AssignTransporter < WaterOrderJob
    def perform(_water_order_id, transporter_id)
      transporter = Transporter.find(transporter_id)
      @water_order.update(transporter: transporter, state: WaterOrder::ASSIGNED_TO_TRANSPORTER)
    end
  end
end
