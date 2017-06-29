require_relative 'acceptance_helper'

feature 'Delete files from question', '
  As user
  I want to delete attached file
  because I have attached it by mistake, for example
' do

  given(:user)         { create(:user) }

  given (:question)    { create(:question, user: user) }
  given!(:attachment)  { create(:attachment, attachable:question) }
  given!(:attachment2) { create(:attachment, attachable:question) }

  given (:question2)   { create(:question) }
  given!(:attachment3) { create(:attachment, attachable:question2) }
  given!(:attachment4) { create(:attachment, attachable:question2) }

  background do
    sign_in(user)
  end

  scenario 'User deletes attachments from his question', js:true do
    visit question_path(question)

    within("li#attach-#{attachment.id}") do
      click_on 'remove attachment'
    end

    within("li#attach-#{attachment2.id}") do
      click_on 'remove attachment'
    end

    expect(page).to_not have_link 'rails_helper.rb'
  end

  scenario 'User try to delete attachments from question of somebody', js:true do
    visit question_path(question2)

    expect(page).to_not have_link 'remove attachment'
  end
end
