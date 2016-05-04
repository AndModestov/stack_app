require 'rails_helper'

feature 'Delete answer' do
  given(:user1){ create(:user) }
  given(:user2){ create(:user) }
  given(:question1){ create(:question, user: user1) }
  given!(:answer2){ create(:answer, user: user2, question: question1) }

  scenario 'User tryes to delete his own answer' do
    log_in(user2)
    visit question_path(question1)
    click_on 'Delete answer'

    expect(page).to have_content 'Answer successfully deleted.'
    expect(page).to_not have_content answer2.body
    expect(current_path).to eq question_path(question1)
  end

  scenario 'User tryes to delete other users answer' do
    log_in(user1)
    visit question_path(question1)

    expect(page).to_not have_link 'Delete answer'
  end
end