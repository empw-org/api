# frozen_string_literal: true

class Company
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial
  include ActiveModel::SecurePassword
  include PasswordDigestRemover

  field :name
  field :email
  field :phone_number
  field :is_approved, type: Boolean, default: false
  field :maintenance, type: Boolean, default: false
  field :password_digest
  field :location, type: Mongoid::Geospatial::Point, sphere: true
  # sphere: true sets the db index for this field

  validates :name, :email, :password_digest,
            :phone_number, :location, presence: true
  validates :email, :phone_number, uniqueness: true
  validates :name, length: { in: 5..100 }
  validates :password, presence: true, length: { in: 8..50 }, allow_nil: true
  validates :email, email: true
  validates :location,  location: true
  validates :phone_number, phone: true

  has_many :water_orders
  has_secure_password
end
