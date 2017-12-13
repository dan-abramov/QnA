require_relative 'acceptance_helper'

feature 'Searching','
  As an user
  I want to be able quickly find
  Necessary information
' do

  given!(:question)  { create(:question, body: 'Hello everybody') }
  given!(:answer)    { create(:answer, question: question, body: 'Hello!') }
  given!(:comment)   { create(:comment, commentable: question, body: 'Hey!') }

  scenario 'Try to find everywhere' do
    ThinkingSphinx::Test.run do
      visit root_path

      within('#new_search') do
        expect(page).to have_button 'Search'
        fill_in 'search', with: 'Hello'
        select 'Everywhere', from: 'condition'
        click_on 'Search'
      end

      expect(current_path).to eq search_index_path
      expect(page).to have_content('Question')
      expect(page).to have_link(question.title)

      expect(page).to have_content('Answer')
      expect(page).to have_link(answer.body)

      expect(page).to have_content('Comment')
      expect(page).to have_link(comment.body)
    end
  end

  ['Questions', 'Answers', 'Comments', 'Users'].each do |klass|
    scenario "Try to find in #{klass}" do
      visit root_path

      within('#new_search') do
        expect(page).to have_button 'Search'
        fill_in 'search', with: 'Hello'
        select klass, from: 'condition'
        save_and_open_page
        click_on 'Search'
      end

      expect(current_path).to eq search_index_path
      expect(page).to have_content(klass.chop)
    end
  end
end
