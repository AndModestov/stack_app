require 'rails_helper'

feature 'Add file to question' do
  given(:user){ create(:user) }

  background do
    log_in(user)
    visit new_question_path
  end

  scenario 'User adds file when asks question', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'Text of the test question'
    click_on 'add file'

    fields = all('input[type="file"]')
    fields[0].set("#{Rails.root}/spec/spec_helper.rb")
    fields[1].set("#{Rails.root}/spec/rails_helper.rb")
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end

end