require 'rails_helper'

feature 'Edit question' do
  given(:user){ create(:user) }
  given!(:question){ create(:question, user: user) }
  given(:wrong_user){ create(:user) }
  given!(:wrong_question){ create(:question, user: wrong_user) }

  describe 'Authenticated user' do
    before{ log_in(user) }

    scenario 'try to edit his question with valid data', js: true do
      visit question_path(question)

      within '.question' do
        click_on 'Edit question'
        fill_in 'Question title:', with: 'new question title'
        fill_in 'Question body:', with: 'new question body'
        click_on 'Save'

        expect(page).to_not have_content question.title && question.body
        expect(page).to have_content 'new question title' && 'new question body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'try to edit his question with invalid data', js: true do
      visit question_path(question)

      within '.question' do
        click_on 'Edit question'
        fill_in 'Question title:', with: ''
        fill_in 'Question body:', with: ''
        click_on 'Save'

        expect(page).to have_content question.title && question.body
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'try to edit other users question' do
      visit question_path(wrong_question)

      within '.question' do
        expect(page).to_not have_link 'Edit question'
      end
    end
  end

  scenario 'Non-Authenticated user try to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

end