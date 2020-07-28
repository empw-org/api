# frozen_string_literal: true

class ConsumptionDataController < ApplicationController
  skip_before_action :authenticate_request, only: :create
  load_and_authorize_resource

  def create
    data = consumption_data_params
    consumption_data = ConsumptionData.new(data)
    if consumption_data.save
      render json: consumption_data, status: :created
    else
      render json: consumption_data.errors, status: :unprocessable_entity
    end
  end

  def index
    aggregation_pipeline = [
      { "$match": { date: Date.yesterday } },
      {
        "$group": {
          _id: { _id: '$sensor_id', date: '$date' },
          data: {
            "$push": {
              water_level: '$water_level',
              created_at: '$created_at'
            }
          }
        }
      },
      {
        "$project": {
          _id: false,
          sensor_id: { "$toString": '$_id._id' },
          date: '$_id.date',
          data: true
        }
      }
    ]
    render json: ConsumptionData.collection.aggregate(aggregation_pipeline)
  end

  private

  def consumption_data_params
    params.require(:consumption_data).permit(:water_level, :sensor_id)
  end
end
