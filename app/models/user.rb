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

  validates_presence_of :name, :email, :password_digest,
                        :phone_number, :ssn, :salary
  validates_uniqueness_of :email, :ssn, :phone_number
  validates :ssn, length: { is: 14 }
  validates :name, length: { in: 5..100 }
  validates :password, presence: true, length: { in: 8..50 }, allow_nil: true
  validates :email, email: true

  has_many :water_orders
  has_secure_password
end
