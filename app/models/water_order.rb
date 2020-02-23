class WaterOrder
  ORDER_STATES = [PENDING = 'PENDING'.freeze,
                  ASSIGNED_TO_COMPANY = 'ASSIGNED_TO_COMPANY'.freeze,
                  READY_FOR_SHIPPING = 'READY_FOR_SHIPPING'.freeze,
                  ASSIGNED_TO_TRANSPORTER = 'ASSIGNED_TO_TRANSPORTER'.freeze,
                  ON_ITS_WAY = 'ON_ITS_WAY'.freeze,
                  DELIVERED = 'DELIVERED'.freeze,
                  CANCELED = 'CANCELED'.freeze].freeze

  include Mongoid::Document
  include Mongoid::Timestamps
  field :amount, type: Integer
  field :state, default: PENDING
  belongs_to :user, class_name: 'User'
  validates_presence_of :amount, :state, :user_id
  validates :state, inclusion: { in: ORDER_STATES }

end
