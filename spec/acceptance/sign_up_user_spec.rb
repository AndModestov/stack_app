require 'rails_helper'

feature 'Sign up user' do

  scenario 'Sign up with valid data' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@mail.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Sign up with invalid data' do
    visit new_user_registration_path
    fill_in 'Email', with: 'usermail.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Email is invalid'
  end
end