require 'rails_helper'

feature 'Add comment' do
  given(:user){ create(:user) }
  given(:question){ create(:question, user: user) }
  given!(:answer){ create(:answer, question: question, user: user) }

  scenario 'Authenticated user comments answer', js: true do
    log_in(user)
    visit question_path(question)

    within '.answers' do
      click_on 'comments'

      within '.answer-comment-form' do
        fill_in 'Your comment:', with: 'Answer comment'
        click_on 'Comment'
      end

      within '.Answer-comments' do
        expect(page).to have_content user[:email]
        expect(page).to have_content 'Answer comment'
      end
    end
  end

  scenario 'Non-authenticated user try to comment answer', js: true do
    visit question_path(question)
    within '.answers' do
      click_on 'comments'
    end

    expect(page).to have_selector '.answer-comment-form', text: ''
  end
end