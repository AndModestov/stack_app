require 'rails_helper'

feature 'Sign in user' do

  scenario 'Log in for registered user' do
    User.create!(email: 'user@mail.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@mail.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully'
    expect(current_path). to eq root_path
  end

  scenario 'Log in for unregistered user' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@mail.com'
    fill_in 'Password', with: 'wrongpassword'

    expect(page).to have_content 'Invalid email or password'
    expect(current_path).to eq new_user_session_path
  end

end