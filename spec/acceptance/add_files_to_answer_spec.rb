require_relative 'acceptance_helper'

feature 'Add files to answer', '
  As user
  I can add file to answer
  to make it more clear
' do

  given(:user)     { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds files when answer', js:true do
    fill_in  'Answer', with: 'Text of answer'
    click_on 'add file'
    within(:xpath, './/form[@class="new_answer"]/div[@id="attachments"]/div[@class="nested-fields"][1]') do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'add file'
    within(:xpath, './/form[@class="new_answer"]/div[@id="attachments"]/div[@class="nested-fields"][2]') do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb',  href: '/uploads/attachment/file/2/spec_helper.rb'
    end
  end
end
