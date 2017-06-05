require 'rails_helper'

feature 'User can view all questions and answers', '
  As user
  I can view all questions
  and answers.
  Non-authenticated user
  can do the same.
' do

  given(:user)     { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answers)  { create_list(:answer, 3, question: question, user: user) }

  scenario 'Authenticated user view question and answers' do
    sign_in(user)
    answers
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

  scenario 'Non-authenticated user view question and answers' do
    answers
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
