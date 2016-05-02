require 'rails_helper'

feature 'User can answer the question' do
  given(:user){ create(:user) }
  given(:question){ create(:question) }

  scenario 'Authenticated user try to answer the question' do
    log_in(user)
    visit question_path(question)
    click_on 'Answer'
    fill_in 'Your answer:', with: 'New test answer for question'
    click_on 'Post'

    expect(page).to have_content 'New test answer for question'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-Authenticated user try to answer the question' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(page).to have_field 'Email'
    expect(page).to have_field 'Password'
    expect(current_path).to eq new_user_session_path
  end
end
