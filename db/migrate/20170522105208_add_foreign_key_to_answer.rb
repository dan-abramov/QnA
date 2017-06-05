# frozen_string_literal: true

class AddForeignKeyToAnswer < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :question_id, :integer
    add_foreign_key :answers, :questions
  end
end
