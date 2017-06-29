require_relative 'acceptance_helper'

feature 'Delete files from answer', '
  As user
  I want to delete attached file
  because I have attached it by mistake, for example
' do

  given(:user)         { create(:user) }
  given(:question)     { create(:question) }

  given!(:answer)      { create(:answer, question: question, user: user) }
  given!(:attachment)  { create(:attachment, attachable: answer) }
  given!(:attachment2) { create(:attachment, attachable: answer) }

  given!(:answer2)     { create(:answer, question: question) }
  given!(:attachment3) { create(:attachment, attachable: answer2) }
  given!(:attachment4) { create(:attachment, attachable: answer2) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User deletes his attachments', js:true do

    within(".answer-#{answer.id}") do
      within("li#attach-#{attachment.id}") do
        click_on 'remove attachment'
      end
      within("li#attach-#{attachment2.id}") do
        click_on 'remove attachment'
      end
    end

    expect(".answer-#{answer.id}").to_not have_link 'rails_helper.rb'
  end

  scenario 'User try to delete attachments of somebody', js:true do
    expect(".answer-#{answer2.id}").to_not have_link 'remove attachment'
  end
end
