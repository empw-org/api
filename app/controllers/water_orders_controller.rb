# frozen_string_literal: true

class WaterOrdersController < ApplicationController
  before_action :set_water_order, only: %i[show destroy mark_as_ready_for_shipping]
  load_and_authorize_resource

  def index
    # return all the orders accessible_by the logged in user
    @water_orders = WaterOrder.accessible_by(current_ability).to_a
    render :index
  end

  def show
    render @water_order
  end

  def create
    e = "You can't have more than #{WaterOrder::MAX_PENDING_ORDERS} PENDING orders"
    return render json: { message: e }, status: :bad_request unless can_order_water?

    data = water_order_params
    data[:user] = @authenticated_user
    water_order = WaterOrder.new(data)

    if water_order.save
      WaterOrderJob::Pending.perform_later(water_order.id.to_s)
      render json: water_order, status: :created
    else
      render json: water_order.errors, status: :unprocessable_entity
    end
  end

  # Transporter
  # POST /water_orders/:id/claim
  def claim
    if @water_order.update({ state: WaterOrder::ASSIGNED_TO_TRANSPORTER, transporter_id: @authenticated_user.id })
      return render json: @water_order
    end

    render json: @water_order.errors, status: :unprocessable_entity
  end

  def mark_as_ready_for_shipping
    if @water_order.update({ state: WaterOrder::READY_FOR_SHIPPING })
      # send to all the online transporters
      WaterOrderJob::ReadyForShipping.perform_later(@water_order.id.to_s)
      return render json: { message: 'request marked as ready for shipping' }
    end
    render json: @water_order.errors, status: :bad_request
  end

  def destroy
    @water_order.destroy
    render status: :no_content
  end

  def destroy_all
    WaterOrder.destroy_all
    render status: :no_content
  end

  private

  def water_order_params
    params.require(:water_order).permit(:amount, location: {})
  end

  def can_order_water?
    pending_orders_count = WaterOrder.where(user: @authenticated_user,
                                            state: WaterOrder::PENDING).count
    pending_orders_count < WaterOrder::MAX_PENDING_ORDERS
  end

  def set_water_order
    @water_order = @authenticated_user.water_orders.find(params[:id])
  end
end
