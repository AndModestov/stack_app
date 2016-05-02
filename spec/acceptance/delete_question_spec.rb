require 'rails_helper'

feature 'Delete question' do
  given(:user1){ create(:user) }
  given(:user2){ create(:user) }
  given(:question){ create(:question, user_id: user1) }

  scenario 'User tryes to delete his own question' do
    log_in(user1)
    visit question_path(question)

    expect(page).to have_link 'Delete question'

    click_on 'Delete question'

    expect(page).to have_content 'Question successfully deleted.'
    expect(page).to_not have_content question.title
    expect(current_path).to eq questions_path
  end

  scenario 'User tryes to delete other users question' do
    log_in(user2)
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'

    visit( question_path(question), method: 'delete' )

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path

  end
end