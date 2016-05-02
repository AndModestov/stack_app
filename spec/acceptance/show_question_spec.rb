require 'rails_helper'

feature 'Show the question with answers' do
  given(:question){ create(:question) }
  given(:answer){ create(:answer, question: question) }

  scenario 'Visitor tryes to watch question' do
    answer
    visit questions_path
    click_on question.title

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
    expect(page).to have_link('Answer', href: new_question_answer_path(question_id: question))
  end
end