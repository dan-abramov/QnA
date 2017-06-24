require_relative 'acceptance_helper'

feature 'Add files to qusetion', '
  As user
  I can add file to question
  to make it more clear
' do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when asks question' do
    fill_in  'Title', with: 'Text question'
    fill_in  'Body',  with: 'Another text'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
  end
end
