require_relative 'acceptance_helper'

feature 'Add comment to answer', '
  As user
  I can add comment
  to answer to clarify or correct some things
' do

  given(:user)     { create(:user) }
  given(:question) { create(:question) }
  given!(:answer)   { create(:answer, question: question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User add comment to answer', js:true do
    within(".answer-#{answer.id}") do
      click_on 'Add comment'
      fill_in 'Comment', with: 'Comment to answer'
      click_on 'Save'
      expect(page).to have_content 'Comment to answer'
    end
  end

  scenario 'Comment for answer appears on another page of user', js:true do
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
    end

    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      within(".answer-#{answer.id}") do
        click_on 'Add comment'
        fill_in 'Comment', with: 'Comment to answer'
        click_on 'Save'
        expect(page).to have_content 'Comment to answer'
      end
    end

    Capybara.using_session('guest') do
      within(".answer-#{answer.id}") do
        expect(page).to have_content 'Comment to answer'
      end
    end
  end
end
