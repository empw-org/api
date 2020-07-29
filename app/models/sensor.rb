# frozen_string_literal: true

class Sensor
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :user
  has_many :consumption_report
  has_many :consumption_data
end
