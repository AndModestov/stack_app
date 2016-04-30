require 'rails_helper'

feature 'User can create question' do

  scenario 'Authenticated user creates question' do
    User.create!(email: 'user@mail.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@mail.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    visit questions_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text of the test question'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
    expect(current_path).to eq questions_path
  end

  scenario 'Not-authenticated user creates question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to new_user_session_path
  end

end