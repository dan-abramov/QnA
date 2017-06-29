require_relative 'acceptance_helper'

feature 'Add files to question', '
  As user
  I can add file to question
  to make it more clear
' do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when asks question', js:true do
    fill_in  'Title', with: 'Text question'
    fill_in  'Body',  with: 'Another text'

    click_on 'add file'

    within(:xpath, './/form[@class="new_question"]/div[@id="attachments"]/div[@class="nested-fields"][1]') do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'add file'
    within(:xpath, './/form[@class="new_question"]/div[@id="attachments"]/div[@class="nested-fields"][2]') do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on 'Create'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/3/rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb',  href: '/uploads/attachment/file/4/spec_helper.rb'
  end
end
