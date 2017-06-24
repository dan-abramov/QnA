# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'View a list of questions', '
  User can view
  a list of questions
' do

  given(:user)      { create(:user) }
  given(:questions) { create_list(:question, 2, user: user) }

  scenario 'Authenticated user can view a list of questions' do
    sign_in(user)
    questions
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end

  scenario 'Non-authenticated user can view a list of questions' do
    questions
    visit questions_path
    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
