require 'rails_helper'

feature 'View a list of questions', '
  User can view
  a list of questions
' do

  given(:user)      { create(:user) }
  given(:questions) { create_list(:question, 5) }

  scenario 'Authenticated user can view a list of questions' do
    questions
    sign_in(user)
    visit questions_path
  end

  scenario 'Non-authenticated user can view a list of questions' do
    questions
    visit questions_path
  end

end
