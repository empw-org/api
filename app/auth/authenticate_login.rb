# frozen_string_literal: true

class AuthenticateLogin
  prepend SimpleCommand

  def initialize(user, model)
    @user = user
    @model = model
  end

  def call
    user = @model.or({ email: @user[:email] },
                     { phone_number: @user[:phone_number] }).first
    return user if user&.authenticate(@user[:password])

    errors.add :message, 'invalid credentials'
    nil
  end
end
