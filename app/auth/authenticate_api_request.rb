class AuthenticateApiRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user = decoded_auth_token && user_with_id(decoded_auth_token[:_id])
    if user
      @user = { user: user, type: decoded_auth_token[:type] }
    else
      errors.add(:token, 'Invalid token') unless errors.key? :token
    end
    @user
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

  def user_with_id(id)
    User.where(id: id).first
  end
end