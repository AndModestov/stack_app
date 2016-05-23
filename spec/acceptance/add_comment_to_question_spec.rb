require 'rails_helper'

feature 'Add comment' do
  given(:user){ create(:user) }
  given!(:question){ create(:question, user: user) }


  scenario 'Authenticated user comments question', js: true do
    log_in(user)
    visit question_path(question)
    click_on 'comments'

    within '.question-comment-form' do
      fill_in 'Your comment:', with: 'Question comment'
      click_on 'Comment'
    end

    expect(page).to have_content user[:email]
    expect(page).to have_content 'Question comment'
  end

  scenario 'Non-authenticated user try to comment question', js: true do
    visit question_path(question)
    click_on 'comments'

    expect(page).to have_selector '.question-comment-form', text: ''
  end
end