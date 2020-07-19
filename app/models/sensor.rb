# frozen_string_literal: true

class Sensor
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :user, optional: true
  has_many :consumption_report
end
