class ContactUs
  include Mongoid::Document
  include Mongoid::Timestamps
  field :message
  field :email
  field :name
  field :from

  validates_presence_of :message, :email, :name, :from
  validates :email, email: true
  validates :from, inclusion: { in: %w[WEB MOB],
                                message: '%{value} must be either WEB or MOB' }
end
