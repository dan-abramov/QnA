# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  validates :body, presence: true
  include Votable

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  default_scope { order(best: :desc) }

  def set_best
    Answer.transaction do
      self.question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end
end
