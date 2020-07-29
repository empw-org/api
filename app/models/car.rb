# frozen_string_literal: true

class Car
  include Mongoid::Document

  field :model, type: Integer
  field :type

  validates :model, :type, presence: true
  validates :type, inclusion: { in: %w[MINI_TRUCK PICKUP] }
  validates :model, numericality: true

  embedded_in :transporter
end
