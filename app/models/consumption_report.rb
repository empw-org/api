class ConsumptionReport
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :water_level, type: Float

  belongs_to :sensor
end
