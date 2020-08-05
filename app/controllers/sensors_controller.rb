# frozen_string_literal: true

class SensorsController < ApplicationController
  load_and_authorize_resource

  # GET /sensors/
  def index
    render json: Sensor.all
  end

  # POST /sensors
  def create
    sensor = Sensor.create(sensor_params)
    return render json: sensor, status: :created if sensor.save

    render json: sensor.errors, status: :unprocessable_entity
  end
  

  # DELETE /sensors/:id
  def destroy
    Sensor.find(params[:id]).destroy
    head :no_content
  end

  private

  def sensor_params
    params.require(:sensor).permit(:user_id)
  end
end
