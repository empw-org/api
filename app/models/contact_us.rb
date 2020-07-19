# frozen_string_literal: true

class ContactUs
  include Mongoid::Document
  include Mongoid::Timestamps
  field :message
  field :email
  field :name
  field :from

  validates :message, :email, :name, :from, presence: true
  validates :email, email: true
  validates :from, inclusion: { in: %w[WEB MOB],
                                message: '%{value} must be either WEB or MOB' }
end
