class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  field :name, type: String
  field :email, type: String
  field :ssn, type: Integer
  field :phone_number, type: String
  field :salary, type: Integer
  field :password_digest
  field :is_verified, default: false

  validates_presence_of :name, :email, :password_digest, :phone_number, :ssn, :salary
  validates_uniqueness_of :email, :ssn, :phone_number
  validates :ssn, length: {is: 14}
  validates :name, length: {in: 5..100}

  index({ssn: 1, phone_number: 1, email: 1}, {unique: true})
  has_secure_password

  def as_json(options = {})
    attrs = super(options)
    attrs.delete("password_digest")
    attrs
  end
end
