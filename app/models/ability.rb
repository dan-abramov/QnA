class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :create,     [Question, Answer, Comment]
    can :update,     [Question, Answer], { user_id: @user.id }
    can :destroy,    [Question, Answer], { user_id: @user.id }

    can :destroy, Attachment do |attachment|
      @user.author_of?(attachment.attachable)
    end

    can :set_best, Answer do |answer|
      @user.author_of?(answer.question)
    end

    can [:vote_up, :vote_down, :vote_reset], [Question, Answer] do |object|
      !@user.author_of?(object)
    end

    can :manage, :profile
  end
end
