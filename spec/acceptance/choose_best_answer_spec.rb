require_relative 'acceptance_helper'

feature 'Choose best answer', '
  As author of question
  I want to choose best answer on my question
' do

  given(:user)      { create(:user) }
  given(:user2)     { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer1)  { create(:answer, question: question) }
  given!(:answer2)  { create(:answer, question: question) }

  scenario 'Author of question choose best answer', js:true do
    sign_in(user)
    visit question_path(question)
    within(".answer-#{answer1.id}") do
      click_on 'choose as best answer'
      expect(page).to_not have_link 'choose as best answer'
    end

    within(".answer-#{answer2.id}") do
      expect(page).to have_link 'choose as best answer'
    end
  end

  scenario 'Somebody try to choose best answer', js:true do
    sign_in(user2)
    visit question_path(question)
    within(".answer-#{answer1.id}") do
      expect(page).to_not have_link 'choose as best answer'
    end
    within(".answer-#{answer2.id}") do
      expect(page).to_not have_link 'choose as best answer'
    end
  end
end
