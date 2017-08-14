require_relative 'acceptance_helper'

feature 'Add comment to question', '
  As user
  I can add comment
  to question to clarify some things
' do

  given(:user)     { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User add comment to question', js:true do
    click_on 'Add Comment'

    fill_in 'Comment', with: 'Comment to question'
    click_on 'Save'

    expect(page).to have_content 'Comment to question'
  end

  scenario 'Comment for question appears on another page of user', js:true do
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
    end

    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      click_on 'Add Comment'

      fill_in 'Comment', with: 'Comment to question'
      click_on 'Save'

      expect(page).to have_content 'Comment to question'
    end

    Capybara.using_session('guest') do
      expect(page).to have_content 'Comment to question'
    end
  end
end
