# frozen_string_literal: true

class WaterOrdersChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from 'transporters'
  end

  def echo(args)
    puts 'ECHO from WATER_ORDER_CHANNEL'
    transmit(args)
    puts 'RECEIVED ARGS'
    pp args
  end

  def accept_order(args)
    puts 'RECEIVED ARGS'
    puts 'accept_order'
    puts '-' * 30
    pp args
    puts '-' * 30
    WaterOrderJob::AssignTransporter.perform_later(args['water_order'], current_user[:_id].to_s)
    transmit(type: 'message', data: { message: "go ahead. it's all yours" })
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end
