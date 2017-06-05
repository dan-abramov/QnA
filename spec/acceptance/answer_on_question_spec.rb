# frozen_string_literal: true

require 'rails_helper'

feature 'Answer on question', '
  As user
  I want to answer on a question
' do

  given(:user)     { create(:user) }
  given(:question) { create(:question) }
  given(:answer)   { create(:answer) }

  scenario 'Authenticated user answer on a question' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    fill_in  'Answer', with: answer[:body]
    click_on 'Create'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end
end
