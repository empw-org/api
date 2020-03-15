class WaterOrderController < ApplicationController
  before_action -> { Authorize.type(@current_user, User) }

  def index
    # return all the requests made by the logged in user
    render json: WaterOrder.where(user: @current_user[:user])
  end

  def create

    data = water_order_params
    data[:user] = @current_user[:user]
    u = WaterOrder.create(data)
    render json: u
  end



  private

  def water_order_params
    params.require(:water_order).permit(:amount)
  end
end
