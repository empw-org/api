class WaterOrdersController < ApplicationController
  before_action :set_water_order, only: %i[show destroy]

  def index
    # return all the requests made by the logged in user
    render json: WaterOrder.where(user: @authenticated_user[:user])
  end

  def show
    render json: @water_order
  end

  def create
    e = "You can't have more than #{WaterOrder::MAX_PENDING_ORDERS} PENDING orders"
    unless can_order_water?
      return render json: { error: e }, status: :bad_request
    end

    data = water_order_params
    data[:user] = @authenticated_user[:user]
    render json: WaterOrder.create(data)
  end

  def destroy
    unless can_delete_water_order?
      return render json: { error: "You can't delete non pending order" },
                    status: :bad_request
    end
    @water_order.destroy
    render status: :no_content
  end


  private

  def water_order_params
    params.require(:water_order).permit(:amount)
  end

  def can_order_water?
    pending_orders_count = WaterOrder.where(user: @authenticated_user[:user],
                                            state: WaterOrder::PENDING).count
    pending_orders_count < WaterOrder::MAX_PENDING_ORDERS
  end

  def can_delete_water_order?
    # can delete an order iff it's pending
    @water_order.state == WaterOrder::PENDING
  end

  def set_water_order
    @water_order = WaterOrder.find_by(user: @authenticated_user[:user],
                                      id: params[:id])
  end
end