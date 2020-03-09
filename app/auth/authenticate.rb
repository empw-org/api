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
    puts 'authenticate user'
    user = User.find_by(@user.slice(:email, :phone_number))
    return user if user&.authenticate(@user[:password])

    errors.add :user_authentication, 'invalid credentials'
    nil
  end
end
