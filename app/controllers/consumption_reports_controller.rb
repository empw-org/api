# frozen_string_literal: true

class ConsumptionReportsController < ApplicationController
  load_and_authorize_resource

  def create
    ConsumptionReport.create(consumption_reports_params[:reports])
    render status: :no_content
  end

  private

  def consumption_reports_params
    params.permit(reports: %i[sensor_id date consumption])
  end
end
