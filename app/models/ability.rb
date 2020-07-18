# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :create, ContactUs
    if user.present?
      can :create, WaterOrder
      can [:read, :delete], WaterOrder, user_id: user.id
    end

    can :manage, :all if user.is_a? Admin
  end
end
