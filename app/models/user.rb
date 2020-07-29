# frozen_string_literal: true

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  include PasswordDigestRemover

  field :name
  field :email
  field :ssn, type: Integer
  field :phone_number
  field :salary, type: Integer
  field :is_verified, default: false
  field :password_digest

  validates :name, :email, :password_digest,
            :phone_number, :ssn, :salary, presence: true
  validates :email, :ssn, :phone_number, uniqueness: true
  validates :ssn, length: { is: 14 }
  validates :name, length: { in: 5..100 }
  validates :password, presence: true, length: { in: 8..50 }, allow_nil: true
  validates :email, email: true
  validates :phone_number, phone: true

  has_one :sensor
  has_many :water_orders
  has_secure_password
end
