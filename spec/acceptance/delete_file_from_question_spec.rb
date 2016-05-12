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
    click_on 'Edit question'

     within '.question' do
       click_on 'delete'

       expect(page).to_not have_link 'spec_helper.rb'
       expect(page).to have_content 'file deleted'
     end
  end
end