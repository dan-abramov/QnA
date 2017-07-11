require_relative 'acceptance_helper'

feature 'User can vote for answer', '
  As user
  I can vote for answer
  I can increase or decrease it rating
' do

  given(:user)       { create(:user) }
  given(:user2)      { create(:user) }
  given(:question)   { create(:question) }
  given!(:answer)    { create(:answer, question: question, user: user) }
  given!(:answer2)   { create(:answer, question: question, user: user2) }

  scenario 'Author of answer can not vote for it', js:true do
    sign_in(user)

    visit question_path(question)

    within(".answer-#{answer.id}-rating") do
      expect(page).to_not have_link '+'
      expect(page).to_not have_link '-'
      expect(page).to_not have_link 'reset'
    end
  end

  scenario 'Somebody can vote for answer of somebody', js:true do
    sign_in(user)

    visit question_path(question)

    within(".answer-#{answer2.id}-rating") do
      click_on '+'
      wait_for_ajax
      expect(page).to have_content '1'
    end
  end

  scenario 'Nobody can vote for answer more than 1 time', js:true do
    sign_in(user)

    visit question_path(question)

    within(".answer-#{answer2.id}-rating") do
      click_on '+'
      visit question_path(question)
      click_on '+'
      expect(page).to have_content '1'
    end
  end
end
