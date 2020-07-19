class Company
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial
  include ActiveModel::SecurePassword
  include PasswordDigestRemover

  field :name
  field :email
  field :phone_number
  field :is_approved, default: false
  field :password_digest
  field :location, type: Mongoid::Geospatial::Point, sphere: true
  # sphere: true sets the db index for this field

  validates_presence_of :name, :email, :password_digest,
                        :phone_number, :location
  validates_uniqueness_of :email, :phone_number
  validates :name, length: { in: 5..100 }
  validates :password, presence: true, length: { in: 8..50 }, allow_nil: true
  validates :email, email: true
  validates :location,  location: true

  has_many :water_orders
  has_secure_password

end
