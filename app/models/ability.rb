class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, :all
    #can [:read,:enter_battle], Battle, user_id: user.id
  end
end
