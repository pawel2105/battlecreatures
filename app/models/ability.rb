class Ability
  include CanCan::Ability

  def initialize(user)
    can :create, Game
    can [:read,:play_letter], Game, user_id: user.id
  end
end
