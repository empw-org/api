class JsonWebToken
  class << self
    def encode(payload)
      JWT.encode(payload, Rails.application.credentials.dig(:secret_key_base))
    end

    def decode(token)
      body = JWT.decode(token,
                        Rails.application.credentials.dig(:secret_key_base))[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
end