# frozen_string_literal: true

class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  default_scope { order(created_at: :asc) }

  after_update :update_notification

  def update_notification
    Subscription.all.find_each do |subscription|
      QuestionUpdateMailer.notificate(subscription).deliver_later unless subscription.user.author_of?(self)
    end
  end
end
