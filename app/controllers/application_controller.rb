# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :authenticated_user

  rescue_from CanCan::AccessDenied do
    head :forbidden
  end

  private

  def authenticate_request
    command = AuthenticateApiRequest.call(request.headers)
    return if (@authenticated_user = command.result)

    render json: command.errors, status: :unauthorized
  end

  def current_user
    @authenticated_user
  end

end