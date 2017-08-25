FactoryGirl.define do
  factory :authorization do
    user
    provider 'twitter'
    uid '123456'
  end
end
