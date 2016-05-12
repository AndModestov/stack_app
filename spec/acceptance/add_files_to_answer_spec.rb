require 'rails_helper'

feature 'Add files to answer' do
  given(:user){ create(:user) }
  given(:question){ create(:question, user: user) }

  background do
    log_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when answers question', js: true do
    fill_in 'Your answer:', with: 'Attached answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end