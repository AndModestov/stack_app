require 'rails_helper'

feature 'Vote answer' do
  given(:user){ create(:user) }
  given(:question){ create(:question, user: user) }
  given(:other_user){ create(:user) }
  given!(:other_question){ create(:question, user: other_user) }

  describe 'Authenticated user' do
    background do
      log_in(user)
      visit question_path(other_question)
    end

    scenario 'votes up for question', js: true do
      within '.question' do
        click_on '+'

        expect(page).to have_content 'Raiting:1'
        expect(page).to have_button('+' , disabled: true)
        expect(page).to have_button('-' , disabled: true)
        expect(page).to have_button('cancel', disabled: false)
      end
    end

    scenario 'votes down for question', js: true do
      within '.question' do
        click_on '-'

        expect(page).to have_content 'Raiting:-1'
        expect(page).to have_button('+' , disabled: true)
        expect(page).to have_button('-' , disabled: true)
        expect(page).to have_button('cancel', disabled: false)
      end
    end

    scenario 'cancels vote for question', js: true do
      within '.question' do
        click_on '+'
        expect(page).to have_content 'Raiting:1'

        click_on 'cancel'
        expect(page).to have_content 'Raiting:0'
        expect(page).to have_button('+' , disabled: false)
        expect(page).to have_button('-' , disabled: false)
        expect(page).to have_button('cancel', disabled: true)
      end
    end

    scenario 'tryes to vote for his own answer', js: true do
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_button '+' && '-' && 'cancel'
      end
    end
  end

  scenario 'Non-Authenticated user tryes to vote for answer', js: true do
    visit question_path(other_question)

    within '.question' do
      expect(page).to_not have_button '+' && '-' && 'cancel'
    end
  end
end