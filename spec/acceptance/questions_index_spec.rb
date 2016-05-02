require 'rails_helper'

feature 'User can watch the questions list' do
  given(:questions){ create_list(:question, 3) }

  scenario 'visitor watches the questions list' do
    questions
    visit questions_path

    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
    expect(page).to have_content questions[2].title
  end
end
