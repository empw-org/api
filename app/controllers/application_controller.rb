class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    @current_user = AuthenticateApiRequest.call(request.headers).result
    unless @current_user
      render json: {error: 'Not Authorized'}, status: :unauthorized
    end
  end
end