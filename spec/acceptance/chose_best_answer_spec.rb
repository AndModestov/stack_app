require 'rails_helper'

feature 'Chose best answer' do
  given(:user){ create(:user) }
  given(:user2){ create(:user) }
  given(:question){ create(:question, user: user) }
  given!(:answers){ create_list(:answer, 2, user: user2, question: question) }


  describe 'Authenticated user' do
    before do
      log_in(user)
      visit question_path(question)
    end

    scenario 'question author try to chose best answer', js: true do

			within '.answers' do
				within "#answer-#{answers.first.id}" do
					click_on 'make best'

          expect(page).to have_content 'Best answer'
        end
      end
		end

		scenario 'question author try to change best answer', js: true do

			within '.answers' do
				within "#answer-#{answers.first.id}" do
					click_on 'make best'
        end

				within "#answer-#{answers.last.id}" do
					click_on 'make best'
					expect(page).to have_content 'Best answer'
        end

				within "#answer-#{answers.first.id}" do
					expect(page).to_not have_content 'Best answer'
				end
      end
		end
  end

  scenario 'other user try to chose best answer' do
    log_in(user2)
    visit question_path(question)

    expect(page).to_not have_link 'make best'
  end

  scenario 'Non-authenticated user try to chose best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'make best'
  end
end