class Ability
  include CanCan::Ability

  def initialize(user)
    can :create, Game
    can :read, Game, user_id: user.id
  end
end
