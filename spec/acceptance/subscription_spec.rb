require_relative 'acceptance_helper'

feature 'User can subscribe/unsubscribe to question', '
  As user
  I can subscribe to get any update of question
  And unsubsribe, if I do not interesting in it
' do

  given(:question)  { create(:question) }
  given!(:user)     { create(:user) }

  scenario 'User try to subscribe on question', js:true do
    sign_in(user)
    visit question_path(question)

    click_on 'Subscribe to updates'

    expect(page).to have_link 'Unsubscribe from updates'
  end

  scenario 'User try to unsubscribe from question', js:true do
    sign_in(user)
    visit question_path(question)

    click_on 'Subscribe to updates'

    expect(page).to have_link 'Unsubscribe from updates'

    click_on 'Unsubscribe from updates'

    expect(page).to have_link 'Subscribe to updates'
  end

  scenario 'Non-autheticated user try to subscribe' do
    visit question_path(question)

    expect(page).to_not have_link 'Subscribe to updates'
  end
end
