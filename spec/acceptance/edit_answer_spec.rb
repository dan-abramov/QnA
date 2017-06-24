require_relative 'acceptance_helper'

feature 'Answer edit', '
  As user
  I want to edit my answer
' do
  given(:user)     { create(:user) }
  given(:question) { create(:question) }
  given!(:answer)   { create(:answer, question: question, user: user) }
  given(:answer2)  { create(:answer, question: question) }

  scenario 'Unauthenticated user try to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to edit' do
      visit question_path(question)
      within '.answers' do
        expect(page).to have_link 'edit'
      end
    end

    scenario 'try to edit his answer', js:true do
      visit question_path(question)
      click_on 'edit'

      within '.answers' do
        fill_in  'Answer', with: 'edited answer'

        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario "try to edit other user's answer" do
      answer2
      visit question_path(question)
      expect(answer2).to_not have_link 'edit'
    end
  end
end
