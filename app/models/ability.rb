# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_accessor :user

  def initialize(input_user)
    return unless input_user

    self.user = input_user
    if user.admin?
      admin_abilities
    else
      user_abilities
    end
  end

  private

    def user_id
      @user_id ||= user&.id
    end

    def admin_abilities
      [Contract, League, Lineup, Player, Roster, Spot, Team,
       User].each do |class_name|
        can :manage, class_name
      end
      cannot :destroy, User, id: user_id
    end

    def user_abilities
      [Contract, League, Lineup, Player, Roster, Spot, Team,
       User].each do |class_name|
        can :read, class_name
      end
      [Lineup, Roster].each do |class_name|
        can :manage, class_name, team: { user_id: }
      end
      can :manage, Spot, lineup: { team: { user_id: } }
      can :update, Team, user_id: user_id
      can :update, User, id: user_id
    end
end
