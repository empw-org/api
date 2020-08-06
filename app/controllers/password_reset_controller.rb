# frozen_string_literal: true

class PasswordResetController < ApplicationController
  skip_before_action :authenticate_request

  # POST /users/reset-password
  def reset_password
    render json: {
      message: 'Please check your email for instructions on password reset'
    }, status: :accepted
    user = User.where(email: params[:email]).first
    if user&.is_verified
      url = reset(user)
      PasswordResetMailer
        .password_reset_email(user.id.to_s, url)
        .deliver_later
    end
  end

  # PATCH /users/password
  def change_password
    token = params[:token]
    # decode without verification
    decoded_data = JWT.decode(token, nil, false)[0].with_indifferent_access
    user = User.find(decoded_data[:id])
    secret_key = generate_secret(user)
    begin
      JWT.decode(token, secret_key, true)
      user.password = params[:password]
      return render json: user.errors, status: :unprocessable_entity unless user.save
    rescue JWT::ExpiredSignature, JWT::VerificationError
      return render json: { message: 'token expired' }, status: :unauthorized
    end
    render json: { message: 'Your password has been changed successfully' }
  end

  private

  def generate_secret(user)
    "#{user.password_digest}#{user.created_at.to_i}"
  end

  def reset(user)
    payload_with_exp = {
      id: user.id.to_s,
      exp: 1.hour.from_now.to_i
    }
    secret = generate_secret(user)
    token = JWT.encode(payload_with_exp, secret)
    "#{ENV['EMPW_RESET_PASSWORD_FRONTEND']}?token=#{token}"
  end
end
