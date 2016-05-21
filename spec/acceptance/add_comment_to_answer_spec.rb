require 'rails_helper'

feature 'Add comment' do
  given(:user){ create(:user) }
  given(:question){ create(:question, user: user) }
  given!(:answer){ create(:answer, question: question, user: user) }


  scenario 'Authenticated user comments answer', js: true do
    log_in(user)
    visit question_path(question)

    within '.answers' do
      fill_in 'Answer comment:', with: 'New comment'
      click_on 'Comment'

      expect(page).to have_content user[:email]
      expect(page).to have_content 'New comment'
    end
  end

  scenario 'Non-authenticated user try to comment answer' do
    visit question_path(question)

    within '.comments' do
      expect(page).to_not have_link 'Comment'
    end
  end
end