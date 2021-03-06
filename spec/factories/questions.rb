FactoryGirl.define do

  factory :question do
    sequence(:title) { |n| "question-#{n}" }
    body 'question description'
    user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
    user nil
  end
end
