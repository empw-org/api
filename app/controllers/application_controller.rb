# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :authenticated_user

  private

  def authenticate_request
    @authenticated_user = AuthenticateApiRequest.call(request.headers).result
    return if @authenticated_user

    render json: { error: 'Not Authorized' }, status: :unauthorized
  end

end