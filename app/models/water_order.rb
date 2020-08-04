# frozen_string_literal: true

class WaterOrder
  ORDER_STATES = [PENDING = 'PENDING',
                  ASSIGNED_TO_COMPANY = 'ASSIGNED_TO_COMPANY',
                  READY_FOR_SHIPPING = 'READY_FOR_SHIPPING',
                  ASSIGNED_TO_TRANSPORTER = 'ASSIGNED_TO_TRANSPORTER',
                  ON_ITS_WAY = 'ON_ITS_WAY',
                  DELIVERED = 'DELIVERED',
                  CANCELED = 'CANCELED'].freeze
  MAX_PENDING_ORDERS = 5

  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial

  field :amount, type: Integer
  field :state, default: PENDING
  field :location, type: Mongoid::Geospatial::Point, sphere: true
  field :cost, type: Hash
  field :distance, type: Float

  belongs_to :user
  belongs_to :transporter, optional: true
  belongs_to :company, optional: true

  validates :amount, :state, :location, :user_id, presence: true
  validates :state, inclusion: { in: ORDER_STATES }
  validates :location, location: true
end
