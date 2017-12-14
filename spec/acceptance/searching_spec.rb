require_relative 'acceptance_helper'

feature 'Searching','
  As an user
  I want to be able quickly find
  Necessary information
' do

  given!(:question)  { create(:question, body: 'test') }
  given!(:answer)    { create(:answer, question: question, body: 'test') }
  given!(:comment)   { create(:comment, commentable: question, body: 'test') }
  given!(:user)      { create(:user, email: 'test@test.com') }

  scenario 'Try to find Everywhere', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within('#new_search') do
        expect(page).to have_button 'Search'
        fill_in 'search', with: 'test'
        click_on 'Search'
      end

      expect(current_path).to eq search_index_path
      expect(page).to have_content('Question')
      expect(page).to have_link(question.title)

      expect(page).to have_content('Answer')
      expect(page).to have_link(answer.body)

      expect(page).to have_content('Comment')
      expect(page).to have_link(comment.body)

      expect(page).to have_content('User')
      expect(page).to have_link(user.email)
    end
  end

  ['Questions', 'Answers', 'Comments', 'Users'].each do |klass|
    scenario "Try to find in #{klass}", js: true do
      ThinkingSphinx::Test.run do
        visit root_path

        within('#new_search') do
          expect(page).to have_button 'Search'
          fill_in 'search', with: 'test'
          select klass, from: 'condition'
          click_on 'Search'
        end

        save_and_open_page
        expect(current_path).to eq search_index_path
        expect(page).to have_content(klass.chop)
      end
    end
  end
end
