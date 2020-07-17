class AuthenticateApiRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    unless (user = decoded_auth_token && find_user)
      errors.add(:token, 'Invalid token') unless errors.key? :token
    end
    user
  end

  private

  attr_reader :headers

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    else
      errors.add(:token, 'Missing token')
    end
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