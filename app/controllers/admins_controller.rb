class AdminsController < ApplicationController
  skip_before_action :authenticate_request, only: :login

  def login
    admin = Admin.where(email: params[:email]).first
    if admin&.authenticate(params[:password])
      render json: { message: 'Logged in successfully',
                     token: TokenMaker.for(admin) }
    else
      render json: { error: 'Wrong email or password' },
             status: :unauthorized
    end
  end
end
