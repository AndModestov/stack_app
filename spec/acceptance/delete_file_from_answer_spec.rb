require 'rails_helper'

feature 'Delete attachment' do
  given(:user){ create(:user) }
  given(:question){ create(:question, user: user) }
  given(:answer){ create(:answer, question: question, user: user) }
  given!(:attachment){ create(:attachment, attachable: answer) }

  background do
    log_in(user)
    visit question_path(question)
  end

  scenario 'delete answers attached file', js: true do
    within '.answers' do
      expect(page).to have_link 'spec_helper.rb'

      click_on 'Edit answer'
      within '.edit_answer' do
        click_on 'remove file'
        click_on 'Save'
      end
      expect(page).to_not have_link 'spec_helper.rb'
    end
  end
end