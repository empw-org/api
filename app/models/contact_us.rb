class ContactUs
  include Mongoid::Document
  field :message
  field :email
  field :name
  validates_presence_of :message, :email, :name
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
