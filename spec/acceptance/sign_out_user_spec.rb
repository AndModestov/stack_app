require 'rails_helper'

feature 'Sign out user' do

  scenario 'Signed in user try to sign out' do
    User.create!(email: 'user@mail.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@mail.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq new_user_session_path
  end

end