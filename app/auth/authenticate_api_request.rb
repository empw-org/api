# frozen_string_literal: true

class AuthenticateApiRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    unless (user = decoded_auth_token && find_user)
      errors.add(:message, 'Invalid token') unless errors.key? :message
    end
    user
  end

  private

  attr_reader :headers

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    return headers['Authorization'].split(' ').last if headers['Authorization'].present?

    errors.add(:message, 'Missing token')
    nil
  end

  def find_user
    type = decoded_auth_token[:type]
    id = decoded_auth_token[:_id]
    model_type = {
      USER: User,
      ADMIN: Admin,
      COMPANY: Company,
      TRANSPORTER: Transporter
    }.with_indifferent_access

    model_type[type].where(id: id).first
  end
end
