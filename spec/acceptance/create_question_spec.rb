# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Create question', '
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
' do

  given(:user)     { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in  'Title', with: question[:title]
    fill_in  'Body',  with: question[:body]
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    expect(page).to_not have_link 'Ask question'
  end

  scenario 'Question appears on another page of user', js:true do
    Capybara.using_session('user') do
      sign_in(user)
      visit questions_path
    end

    Capybara.using_session('guest') do
      visit questions_path
    end

    Capybara.using_session('user') do
      click_on 'Ask question'
      fill_in  'Title', with: question[:title]
      fill_in  'Body',  with: question[:body]
      click_on 'Create'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    Capybara.using_session('guest') do
      expect(page).to have_content question.title
    end
  end
end
