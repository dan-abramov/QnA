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
    can :update,     [Question, Answer], { user: @user }
    can :destroy,    [Question, Answer], { user: @user }

    can :destroy, Attachment do |attachment|
      attachment.attachable.user_id == @user.id
    end

    can :set_best, Answer do |answer|
      answer.question.user_id == @user.id
    end

    can [:vote_up, :vote_down, :vote_reset], [Question, Answer] do |object|
      object.user_id != @user.id
    end
  end
end
