# frozen_string_literal: true

class Authenticate
  prepend SimpleCommand

  def initialize(user)
    @user = user
  end

  def call
    authenticate
  end

  private

  def authenticate
    user = User.or({ email: @user[:email] },
                   { phone_number: @user[:phone_number] }).first
    return user if user&.authenticate(@user[:password])

    errors.add :user_authentication, 'invalid credentials'
    nil
  end
end
