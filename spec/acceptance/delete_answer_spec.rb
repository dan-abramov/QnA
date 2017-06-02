require 'rails_helper'

feature 'Delete answer', '
  As user
  I can delete my own answer.
  And nobody can do it instead.
' do

  given(:user1)    { create(:user) }
  given(:user2)    { create(:user) }
  given(:question) { create(:question) }
  given(:answer)  { create(:answer, question: question, user: user1) }

  scenario 'User1 is deleting his answer' do
    sign_in(user1)
    answer
    visit question_path(question)
    click_on 'delete answer'
    expect(page).to_not have_content answer.body
  end
  
  scenario 'User2 can not delete answer of User1' do
    sign_in(user1)
    answer
    visit question_path(question)
    sign_out(user1)

    sign_in(user2)
    visit question_path(question)
    expect(page).to_not have_link 'delete answer'
  end
end
