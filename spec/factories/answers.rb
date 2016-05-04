FactoryGirl.define do
  factory :answer do
    sequence(:body){ |n| "This is answer #{n}" }
    question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question
    user
  end
end
