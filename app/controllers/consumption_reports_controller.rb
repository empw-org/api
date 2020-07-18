class ConsumptionReportsController < ApplicationController
  skip_before_action :authenticate_request, only: :create

  def create
    data = consumption_report_params
    consumption_report = ConsumptionReport.new(data)
    if consumption_report.save
      render json: consumption_report, status: :created
    else
      render json: consumption_report.errors, status: :unprocessable_entity
    end
  end

  def consumption_report_params
    params.require(:consumption_report).permit(:water_level, :sensor_id)
  end
end
