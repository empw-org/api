# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :create, ContactUs
    can :create, ConsumptionData
    can %i[login signup verify], User
    can %i[login signup], Company
    can %i[login signup], Transporter

    if user.is_a? User
      can %i[show update], User, _id: user.id
      can :create, WaterOrder
      can :read, ConsumptionReport
      can :read, WaterOrder, user_id: user.id
      can :destroy, WaterOrder, user_id: user.id, state: WaterOrder::PENDING
    end

    if user.is_a? Transporter
      can %i[show update statistics update_image current_water_order], Transporter, _id: user.id
      can %i[read], WaterOrder, transporter_id: user.id
      can %i[read claim], WaterOrder, state: WaterOrder::READY_FOR_SHIPPING
      can %i[pick], WaterOrder, state: WaterOrder::ASSIGNED_TO_TRANSPORTER, transporter_id: user.id
      can %i[deliver], WaterOrder, state: WaterOrder::ON_ITS_WAY, transporter_id: user.id
    end

    if user.is_a? Company
      can :read, WaterOrder, company_id: user.id
      can %i[update show statistics], Company, _id: user.id
      can :mark_as_ready_for_shipping, WaterOrder,
          company_id: user.id, state: WaterOrder::ASSIGNED_TO_COMPANY
    end

    can :manage, :all if user.is_a? Admin
  end
end
