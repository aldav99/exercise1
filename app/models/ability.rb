class Ability
  include CanCan::Ability

  attr_reader :user

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
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id
    
    can :create, Attachment
    can :destroy, Attachment, attachmentable: { user_id: user.id }

    can [:vote_up,:vote_down], [Question, Answer] do |votable|
      !user.author_of?(votable)
    end

    cannot :vote_up, [Question, Answer], votes: { user_id: user.id }
    can :vote_reset, [Question, Answer], votes: { user_id: user.id }

    can :best, Answer, question: { user_id: user.id }
  end
end
