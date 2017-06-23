require_relative 'acceptance_helper'

feature 'best answer become first', '
  If author choose best answer
  it becomes first in queue
' do

  given(:user)      { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer1)  { create(:answer, question: question) }
  given!(:answer2)  { create(:answer, question: question, best:true) }

  scenario 'After choosing as best answer becomes first', js:true do
    sign_in(user)
    visit question_path(question)
    first_answer = find(:xpath, './/div[@class="answers"]/div[1]')
    expect(first_answer[:class]).to eq "answer-2"
  end
end
