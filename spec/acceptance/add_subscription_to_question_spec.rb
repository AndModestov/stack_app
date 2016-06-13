require 'rails_helper'

feature 'Add subscription' do
  given(:user){ create(:user) }
  given(:question){ create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      log_in(user)
      visit question_path(question)
    end

    scenario 'subscribes to question', js: true do
      within '.question' do
        click_on 'Subscribe'
        expect(page).to have_link 'Unsubscribe'
      end
    end

    scenario 'unsubscribes to question', js: true do
      within '.question' do
        click_on 'Subscribe'
        click_on 'Unsubscribe'
        expect(page).to have_link 'Subscribe'
      end
    end
  end

  describe 'Non-authenticated user' do
    scenario 'tries to subscribe to question', js: true do
      visit question_path(question)
      within '.question' do
        expect(page).to_not have_content 'Subscribe'
        expect(page).to_not have_content 'Unsubscribe'
      end
    end
  end
end