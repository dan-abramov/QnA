# frozen_string_literal: true

require 'rails_helper'

feature 'Delete question', '
  As user
  I can delete my own question.
  And nobody can do it instead.
' do

  given(:user1)    { create(:user) }
  given(:user2)    { create(:user) }
  given(:question) { create(:question, user: user1) }

  scenario 'User1 is deleting his question' do
    sign_in(user1)
    question
    visit questions_path
    click_on 'delete question'

    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
  end

  scenario 'User2 try to delete question of User1' do
    sign_in(user2)
    question
    visit questions_path
    expect(page).to_not have_link 'delete question'
  end
end
