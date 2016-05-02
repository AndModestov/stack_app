FactoryGirl.define do
  factory :answer do
    sequence(:body){ |n| "This is answer #{n}" }
    question
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question
  end
end
