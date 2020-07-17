class Admin
  include Mongoid::Document
  include ActiveModel::SecurePassword
  include PasswordDigestRemover

  field :email
  field :password_digest

  validates :password, presence: true, length: { in: 8..50 }, allow_nil: true
  validates :email, email: true, uniqueness: true


  has_secure_password
end
