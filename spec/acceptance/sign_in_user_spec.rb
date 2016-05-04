require 'rails_helper'

feature 'Sign in user' do
  given(:user){ create(:user) }

  scenario 'Log in for registered user' do
    log_in(user)

    expect(page).to have_content 'Signed in successfully'
    expect(current_path). to eq root_path
  end

  scenario 'Log in for unregistered user' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@mail.com'
    fill_in 'Password', with: 'wrongpassword'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password'
    expect(current_path).to eq new_user_session_path
  end
end