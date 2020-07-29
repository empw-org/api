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
      can %i[read delete], WaterOrder, user_id: user.id
    end

    if user.is_a? Transporter
      can %i[show update], Transporter, _id: user.id
    end

    if user.is_a? Company
      can :read, WaterOrder, company_id: user.id
      can %i[update show], Company, _id: user.id
      can :mark_as_ready_for_shipping, WaterOrder,
          company_id: user.id, state: WaterOrder::ASSIGNED_TO_COMPANY
    end

    can :manage, :all if user.is_a? Admin
  end
end
