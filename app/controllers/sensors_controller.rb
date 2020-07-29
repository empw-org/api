# frozen_string_literal: true

class SensorsController < ApplicationController
  load_and_authorize_resource

  def index
    render json: Sensor.all
  end

  def create
    sensor = Sensor.create(sensor_params)
    return render json: sensor, status: :created if sensor.save

    render json: sensor.errors, status: :unprocessable_entity
  end

  private

  def sensor_params
    params.require(:sensor).permit(:user_id)
  end
end
