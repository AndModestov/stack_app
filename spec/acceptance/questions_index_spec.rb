require 'rails_helper'

feature 'User can watch the questions list' do
  given(:questions){ create_list(:question, 3) }

  scenario 'Visitor tryes to watch the questions list' do
    questions
    visit questions_path

    questions.each do |question|
      expect(page).to have_link(question.title, href: question_path(question))
    end

    expect(page).to have_link('Ask question', href: new_question_path )
  end
end
