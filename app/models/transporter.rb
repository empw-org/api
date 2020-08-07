# frozen_string_literal: true

class Transporter
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial
  include ActiveModel::SecurePassword
  include PasswordDigestRemover

  field :name
  field :email
  field :phone_number
  field :address
  field :image
  field :is_approved, default: false
  field :password_digest
  field :ssn, type: Integer

  validates :name, :email, :phone_number, :password_digest, :ssn, :car, :address, presence: true
  validates :email, :phone_number, :ssn, uniqueness: true
  validates :name, length: { in: 5..100 }
  validates :address, length: { in: 10..100 }
  validates :ssn, length: { is: 14 }
  validates :password, presence: true, length: { in: 8..50 }, allow_nil: true
  validates :email, email: true
  validates :phone_number, phone: true

  embeds_one :car
  has_many :water_orders

  has_secure_password
end
