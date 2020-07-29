# frozen_string_literal: true

class ConsumptionReportsController < ApplicationController
  load_and_authorize_resource

  def create
    ConsumptionReport.create(consumption_reports_params[:reports])
    render status: :no_content
  end

  def index
    return render json: @authenticated_user.sensor.consumption_report if @authenticated_user.sensor

    render json: { message: "You don't have a sensor connected to your account" }, status: :bad_request
  end

  private

  def consumption_reports_params
    params.permit(reports: %i[sensor_id date consumption])
  end
end
