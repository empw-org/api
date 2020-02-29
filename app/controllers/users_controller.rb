# app/controllers/users_controller.rb
class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login register verify]
  # POST /register
  def register
    @user = User.create(user_params)
    if @user.save
      TwilioVerification.send_code_to(@user.phone_number)
      render json: {message: 'SMS Sent'}, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # POST /login
  def login
    authenticate
  end

  # POST /verify
  def verify
    command = AuthenticateUser.call user_params
    user = command.result
    if command.success? && user.is_verified || TwilioVerification.correct_code?(user.phone_number,
                                                            params[:code])
      user.is_verified = true
      user.save
      render json: {user: user, message: 'verification successful', token: JsonWebToken.encode(user._id)}
    else
      render json: {error: command.errors}, status: :unauthorized
    end
  end

  def test
    render json: {message: 'You have passed authentication and authorization test'}
  end

  private

  def user_params
    params.permit(
        :name,
        :email,
        :password,
        :phone_number,
        :ssn,
        :salary
    ).to_h
  end

  def authenticate
    command = AuthenticateUser.call user_params
    user = command.result
    if command.success?
      render json: {user: user, token: JsonWebToken.encode(user._id)}
    else
      render json: {error: command.errors}, status: :unauthorized
    end
  end
end