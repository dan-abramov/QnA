# frozen_string_literal: true

FactoryGirl.define do
  factory :question do
    title 'Question title'
    body 'Question body'
    user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
