class JsonWebToken

  SECRET_KEY_BASE = Rails.application.credentials.dig(:secret_key_base)

  class << self
    def encode(payload)
      JWT.encode(payload, SECRET_KEY_BASE)
    end

    def decode(token)
      body = JWT.decode(token, SECRET_KEY_BASE)[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
end