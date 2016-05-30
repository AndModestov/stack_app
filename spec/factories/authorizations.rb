FactoryGirl.define do
  factory :authorization do
    user
    provider "facebook"
    uid "123456"
  end
end
