# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Answer on question', '
  As user
  I want to answer on a question
' do

  given(:user)     { create(:user) }
  given(:question) { create(:question) }
  given(:answer)   { create(:answer) }

  scenario 'Authenticated user answer on a question', js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    fill_in  'Answer', with: answer[:body]
    click_on 'Create'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    within '.answers' do
      expect(page).to have_content answer.body
    end
  end

  scenario 'User try to create invalid answer', js:true do
    sign_in(user)

    visit question_path(question)

    click_on 'Create'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Answer appears on another page of user', js:true do
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
    end

    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      fill_in  'Answer', with: answer[:body]
      click_on 'Create'

      expect(page).to have_content answer.body
    end

    Capybara.using_session('guest') do
      expect(page).to have_content answer.body
    end
  end
end
