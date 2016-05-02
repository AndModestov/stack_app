require 'rails_helper'

feature 'User can watch the questions list' do
  given(:questions){ create_list(:question, 3) }

  scenario 'Visitor tryes to watch the questions list' do
    questions
    visit questions_path

    expect(page).to have_link(questions[0].title, href: question_path(questions[0]))
    expect(page).to have_link(questions[1].title, href: question_path(questions[1]))
    expect(page).to have_link(questions[2].title, href: question_path(questions[2]))
    expect(page).to have_link('Ask question', href: new_question_path )
  end
end
