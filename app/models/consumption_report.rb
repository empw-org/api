# frozen_string_literal: true

class ConsumptionReport
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :consumption, type: Float
  field :date, type: Date

  validates :consumption, numericality: true

  belongs_to :sensor
end
