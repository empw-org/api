class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login signup verify]
  # POST /signup
  def signup
    @user = User.new(user_params)
    twilio_verification = nil
    if @user.valid?
      twilio_verification = TwilioVerification.send_code_to(@user.phone_number)
    end
    if twilio_verification && @user.save
      render json: { message: 'Registered Successfully. ' \
                     'An SMS with verification code was sent to the number' },
             status: :created
      UserMailer.welcome_email(@user.id.to_s).deliver_later
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
    command = Authenticate.call user_params
    user = command.result

    if command.success?
      if TwilioVerification.correct_code?(user.phone_number,
                                          params[:code])
        # first time login: mark as verified
        user.is_verified = true
        user.save
      else # wrong verification token
        return render json: { error: command.errors,
                              message: 'Wrong verification code' },
                      status: :unauthorized
      end
      render json: { user: user,
                     message: 'verification successful',
                     token: TokenMaker.for(user) }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end

  private

  def user_params
    pp params
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
    command = Authenticate.call user_params
    user = command.result
    if command.success?
      render json: { user: user, token: TokenMaker.for(user) }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end
end
