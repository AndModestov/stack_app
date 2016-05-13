require 'rails_helper'

feature 'Delete attachment' do
  given(:user){ create(:user) }
  given(:question){ create(:question, user: user) }
  given!(:attachment){ create(:attachment, attachable: question) }

  background do
    log_in(user)
    visit question_path(question)
  end

  scenario 'delete questions attached file', js: true do
    within '.question' do
      expect(page).to have_link 'spec_helper.rb'

      click_on 'Edit question'
      click_on 'remove file'
      click_on 'Save'

      expect(page).to_not have_link 'spec_helper.rb'
    end
  end
end