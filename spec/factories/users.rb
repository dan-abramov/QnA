# frozen_string_literal: true

FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@for_test.com"
  end

  factory :user do
    email
    password '12345678'
    password_confirmation '12345678'
    uid '123456'
  end
end
