module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    votes.sum(:value)
  end

  def vote_up(current_user)
    if !current_user.author_of?(self)
      vote_reset(current_user)
      votes.create!(value: 1, user_id: current_user.id)
    end
  end

  def vote_down(current_user)
    if !current_user.author_of?(self)
      vote_reset(current_user)
      votes.create!(value: -1, user_id: current_user.id)
    end
  end

  def vote_reset(current_user)
    if !current_user.author_of?(self)
      votes.where(user_id: current_user.id).delete_all
    end
  end

  def voted?(current_user)
    votes.exists?(user_id: current_user.id)
  end
end
