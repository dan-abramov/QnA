# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user
  validates :title, :body, presence: true
  include Votable

  accepts_nested_attributes_for :attachments, reject_if: :all_blank
end
