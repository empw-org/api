# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :create, ContactUs
    can %i[login signup], Company

    if user.is_a? User
      can :create, WaterOrder
      can %i[read delete], WaterOrder, user_id: user.id
    end

    if user.is_a? Company
      can :mark_as_ready_for_shipping, WaterOrder,
          company_id: user.id, state: WaterOrder::ASSIGNED_TO_COMPANY
    end

    can :manage, :all if user.is_a? Admin
  end
end
