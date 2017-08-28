require_relative 'acceptance_helper'

feature 'OmniAuth', '
  I want to my users
  can authorize through
  vkontakte, facebook adn twitter
' do
  scenario 'Unauthorized user try to authorize through Facebook' do
    visit questions_path

    click_on 'Sign in'
    mock_auth_hash(:facebook)
    click_link 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account.'
    expect(page).to have_link 'Sign out'
  end

  scenario 'Unauthorized user try to authorize through Vkontakte' do
    visit questions_path

    click_on 'Sign in'
    mock_auth_hash(:vkontakte)
    click_link 'Sign in with Vkontakte'

    expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    expect(page).to have_link 'Sign out'
  end

  describe 'Unauthorized user try to authorize through Twitter' do
    background do
      visit questions_path
      click_on 'Sign in'
    end

    scenario 'User has never authorized before' do
      click_link 'Sign in with Twitter'
      fill_in 'email_email', with: 'new@email.com'
      click_on 'Submit'
      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(page).to have_link 'Sign out'
    end

    scenario 'User has authorized before' do
      click_link 'Sign in with Twitter'
      fill_in 'email_email', with: 'new@email.com'
      click_on 'Submit'
      click_on 'Sign out'
      click_on 'Sign in'
      click_link 'Sign in with Twitter'
      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(page).to have_link 'Sign out'
    end
  end
end
