require 'rails_helper'

feature 'Add files to answer' do
  given(:user){ create(:user) }
  given(:question){ create(:question, user: user) }

  background do
    log_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when answers question', js: true do

    within '.new_answer' do
      fill_in 'Your answer:', with: 'Attached answer'
      click_on 'add file'

      fields = all('input[type="file"]')
      fields[0].set("#{Rails.root}/spec/spec_helper.rb")
      fields[1].set("#{Rails.root}/spec/rails_helper.rb")

      click_on 'Answer'
    end
    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end
end
