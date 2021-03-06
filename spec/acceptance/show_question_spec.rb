require 'rails_helper'

feature 'Show the question with answers' do
  given(:question){ create(:question) }
  given!(:answers){ create_list(:answer, 3, question: question) }

  scenario 'Visitor tryes to watch question' do
    visit questions_path
    click_on question.title

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to_not have_field 'Your answer:'
    expect(page).to_not have_button 'Answer'
    expect(page).to_not have_link 'Edit question'

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end