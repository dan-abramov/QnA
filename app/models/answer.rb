# frozen_string_literal: true

class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  default_scope { order(best: :desc) }

  after_create :send_new_answer_notification


  def set_best
    Answer.transaction do
      self.question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end

  private

  def send_new_answer_notification
    AnswerNotificationJob.perform_later(self)
  end
end
