class SensorsController < ApplicationController
  load_and_authorize_resource

  def index
    render json: Sensor.all
  end

  def create
    render json: Sensor.create, status: :created
  end
end
