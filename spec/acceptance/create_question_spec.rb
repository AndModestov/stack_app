require 'rails_helper'

feature 'User can create question' do
  given(:user){ create(:user) }

  scenario 'Authenticated user creates question' do
    log_in(user)

    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'Text of the test question'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
    expect(current_path).to eq question_path(Question.last)
  end

  scenario 'Not-authenticated user creates question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end
end