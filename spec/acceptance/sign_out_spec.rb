# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'User sign out', '
  As user
  I want to end my session
' do

  given(:user) { create(:user) }

  scenario 'User click button "Sign out"' do
    sign_in(user)
    visit root_path
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end
