require 'rails_helper'
include ActiveJob::TestHelper

feature 'Add subscription' do
  given(:user){ create(:user) }
  given(:other_user){ create(:user) }
  given(:question){ create(:question, user: other_user) }

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

    scenario 'receives email with answer', js: true do
      click_on 'Subscribe'

      fill_in 'Your answer:', with: 'New test answer for question'
      perform_enqueued_jobs do
        click_on 'Answer'
      end
      open_email(user.email)
      expect(current_email).to have_content 'New test answer for question'
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