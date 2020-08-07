# frozen_string_literal: true

class WaterOrdersChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from 'transporters'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end
