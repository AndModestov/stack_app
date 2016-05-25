require 'rails_helper'

feature 'Delete question' do
  given(:user1){ create(:user) }
  given(:user2){ create(:user) }
  given(:question){ create(:question, user: user1) }

  scenario 'User tryes to delete his own question' do
    log_in(user1)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Question was successfully destroyed.'
    expect(page).to_not have_content question.title
    expect(current_path).to eq questions_path
  end

  scenario 'User tryes to delete other users question' do
    log_in(user2)
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end