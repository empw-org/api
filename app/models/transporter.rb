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
  field :is_approved, default: false
  field :password_digest
  field :ssn, type: Integer
  embeds_one :car

  validates :name, :email, :phone_number, :password_digest, :ssn, :car, presence: true
  validates :email, :phone_number, :ssn, uniqueness: true
  validates :name, length: { in: 5..100 }
  validates :ssn, length: { is: 14 }
  validates :password, presence: true, length: { in: 8..50 }, allow_nil: true
  validates :email, email: true

  has_many :water_orders
  has_secure_password
end


class Car
  include Mongoid::Document
  field :model
  field :number
  field :capacity, type: Integer

  validates :model, :number, :capacity, presence: true

  embedded_in :transporter
end