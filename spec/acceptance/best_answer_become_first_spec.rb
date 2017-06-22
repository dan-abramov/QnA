require_relative 'acceptance_helper'

feature 'best answer become first', '
  If author choose best answer
  it becomes first in queue
' do

  given(:user)      { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer1)  { create(:answer, question: question) }
  given!(:answer2)  { create(:answer, question: question) }

  scenario 'After choosing as best answer becomes first', js:true do
    sign_in(user)
    visit question_path(question)
    within(".answer-#{answer2.id}") do
      click_on 'choose as best answer'
    end
    sleep(1)
    Answer.order(best: :desc).all.should == [answer2, answer1]
  end
end
