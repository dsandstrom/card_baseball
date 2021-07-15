# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_accessor :user

  def initialize(input_user)
    return unless input_user

    self.user = input_user
    if user.admin?
      can :manage, League
      can :manage, Team
      can :manage, User
      cannot :destroy, User, id: user_id
    else
      can :read, User
      can :update, User, id: user_id
      can :read, League
      can :read, Team
      can :update, Team, user_id: user_id
    end
  end

  private

    def user_id
      @user_id ||= user&.id
    end
end
