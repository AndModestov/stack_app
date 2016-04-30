require 'rails_helper'

feature 'Sign up user' do

  scenario 'Sign up with valid data' do
    visit new_user_path
    fill_in 'Email', with: 'user@mail.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Signed up successfully'
    expect(current_path).to eq questions_path
  end

  scenario 'Sign up with invalid data' do
    visit new_user_path
    fill_in 'Email', with: 'usermail.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'wrong password or email'
    expect(current_path).to eq new_user_path
  end
end