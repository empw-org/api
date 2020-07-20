# frozen_string_literal: true

class AdminsController < ApplicationController
  skip_before_action :authenticate_request, only: :login

  def login
    command = AuthenticateLogin.call(params, Admin)
    admin = command.result
    return render json: { admin: admin, token: TokenMaker.for(admin) } if command.success?

    render json: command.errors, status: :unauthorized
  end
end
