require_relative 'acceptance_helper'

feature 'User can vote for question', '
  As user
  I can vote for question
  I can increase or decrease it rating
' do

  given!(:user)      { create(:user) }
  given(:user2)     { create(:user) }
  given(:question)  { create(:question, user: user) }

  scenario 'Author can not vote for his question', js:true do
    sign_in(user)

    visit question_path(question)

    within('.rating') do
      expect(page).to_not have_link '+'
      expect(page).to_not have_link '-'
      expect(page).to_not have_link 'reset'
    end
  end

  scenario 'Somebody can vote for question of somebody', js:true do
    sign_in(user2)

    visit question_path(question)

    within('.rating') do
      click_on '+'
      wait_for_ajax
      expect(page).to have_content '1'
    end
  end

  scenario 'Nobody can vote for question more than 1 time', js:true do
    sign_in(user2)
    visit question_path(question)

    within('.rating') do
      click_on '+'
      visit question_path(question)
      click_on '+'
      expect(page).to have_content '1'
    end
  end
end
