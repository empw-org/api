# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :create, ContactUs unless user.present?

    can :manage, ContactUs if user.is_a? Admin
  end
end
