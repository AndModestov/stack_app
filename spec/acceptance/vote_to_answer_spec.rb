require 'rails_helper'

feature 'Vote answer' do
  given(:user){ create(:user) }
  given(:question){ create(:question, user: user) }
  given(:answer){ create(:answer, user: user, question: question) }
  given(:other_user){ create(:user) }
  given!(:other_answer){ create(:answer, user: other_user, question: question ) }

  background do
    log_in(user)
    visit question_path(question)
  end

  describe 'Authenticated user' do
    scenario 'votes up for answer', js: true do
      within '.answers' do
        click_on '+'
        expect(page).to have_content 'raiting: 1'
        click_on '+'
        expect(page).to have_content 'raiting: 1'
      end
    end

    scenario 'votes down for answer', js: true do
      within '.answers' do
        click_on '-'
        expect(page).to have_content 'raiting: -1'
        click_on '-'
        expect(page).to have_content 'raiting: -1'
      end
    end

    scenario 'cancels vote for answer', js: true do
      within '.answers' do
        click_on '+'
        expect(page).to have_content 'raiting: 1'

        click_on '-'
        expect(page).to have_content 'raiting: 0'
      end
    end

    scenario 'tryes to vote for his own answer', js: true do
      answer
      visit question_path(question)

      within '.answers' do
        within '#answer-2' do
          expect(page).to_not have_link '+' && '-'
        end
      end
    end
  end

  scenario 'Non-Authenticated user tryes to vote for answer', js: true do
    within '.answers' do
      expect(page).to_not have_link '+' && '-'
    end
  end
end