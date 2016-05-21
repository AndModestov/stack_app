require 'rails_helper'

feature 'Add comment' do
  given(:user){ create(:user) }
  given!(:question){ create(:question, user: user) }


  scenario 'Authenticated user comments question', js: true do
    log_in(user)
    visit question_path(question)
    within '.question-comment-form' do
      fill_in 'Your comment:', with: 'New comment'
      click_on 'Comment'
    end
   save_and_open_page
    expect(page).to have_content user[:email]
    expect(page).to have_content 'New comment'

  end

  scenario 'Non-authenticated user try to comment question' do
    visit question_path(question)

    within '.question-comment-form' do
      expect(page).to_not have_link 'Comment'
    end
  end
end