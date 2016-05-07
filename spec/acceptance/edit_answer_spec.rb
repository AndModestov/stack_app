require 'rails_helper'

feature 'Edit answer' do
  given(:user){ create(:user) }
  given(:question){ create(:question) }
  given!(:answer){ create(:answer, user: user, question: question) }
  given(:user2){ create(:user) }
  given!(:answer2){ create(:answer, user: user2, question: question) }

  describe 'Authenticated user' do
    before do
      log_in(user)
      visit question_path(question)
    end

    scenario 'try to edit his answer with valid data', js: true do
      within '.answers' do
        expect(page).to have_link 'Edit answer'

        click_on 'Edit answer'
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'try to edit his answer with invalid data', js: true do
      within '.answers' do
        click_on 'Edit answer'
        fill_in 'Answer', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'try to edit other users answer' do
      within '#answer-2' do
        expect(page).to_not have_link 'Edit answer'
      end
    end
  end

  scenario 'Not Authenticated user try to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end
end