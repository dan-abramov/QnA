# frozen_string_literal: true

class AddUserIdToAnswersAndQuestions < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :answers, :user
    add_belongs_to :questions, :user
  end
end
