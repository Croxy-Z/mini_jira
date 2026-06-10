# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    user

    title { Faker::App.name }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
  end
end
