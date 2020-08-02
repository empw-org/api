# frozen_string_literal: true

class UsersController < ApplicationController
  wrap_parameters :user, include: User.attribute_names + [:password]
  skip_before_action :authenticate_request, only: %i[login signup verify]
  load_and_authorize_resource

  # POST /users/signup
  def signup
    user = User.new(user_params)
    VerificationMessageJob.perform_later(user.phone_number) if user.valid?
    if user.save
      render json: {
        message: "Registered Successfully. An SMS with verification code will be sent to #{user.phone_number}"
      }
      UserMailer.welcome_email(user.id.to_s).deliver_later
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  # POST /users/login
  def login
    command = AuthenticateLogin.call(user_params, User)
    user = command.result
    if command.success?
      unless user.is_verified
        return render json: { message: 'Please verify your account to login' },
                      status: :unauthorized
      end

      render json: { user: user, token: TokenMaker.for(user) }
    else
      render json: command.errors, status: :unauthorized
    end
  end

  # PATCH /verify
  def verify
    command = AuthenticateLogin.call(user_params, User)
    user = command.result
    if command.success?
      if user.is_verified || TwilioVerification.correct_code?(user.phone_number,
                                                              params[:code])
        # already verified or first time login
        # user.update is true if success (won't re-save if nothing changed)
        user.update(is_verified: true)
        return render json: { user: user,
                              message: 'Verified successfully',
                              token: TokenMaker.for(user) }
      else
        # wrong verification token
        command.errors.add(:message, 'Wrong verification code')
      end
    end
    render json: command.errors, status: :unauthorized
  end

  # GET /user
  def show
    render json: @authenticated_user
  end

  # PATCH /user
  def update
    return render json: @authenticated_user if @authenticated_user.update(user_params)

    render json: @authenticated_user.errors, status: :unprocessable_entity
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :phone_number,
      :ssn,
      :salary
    )
  end
end
