# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new # guest user (not logged in)

    can :read, [Location, Comment]

    if user&.user?
      can %i(update read), User, id: user.id
      can :manage, Comment
      can %i(read create update seach_yard_for_booking), Booking
    end

    can :manage, :all if user&.admin?
  end
end
