require 'rails_helper'

feature 'User registration', '
  As a visitor I want to
  registrate myself
' do

  scenario 'A visitor tries to register itself' do
    visit root_path
    click_on 'Sign up'
    visit new_user_registration_path


    fill_in 'Email',                       with: 'some@email.com'
    fill_in 'user[password]',              with: '12345678'
    fill_in 'user[password_confirmation]', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end
end
