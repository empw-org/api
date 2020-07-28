# frozen_string_literal: true

class ConsumptionData
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :water_level, type: Float
  field :date, type: Date, default: Date.today

  validates :water_level, numericality: true

  belongs_to :sensor
end
