# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    project

    title { Faker::Lorem.sentence(word_count: 4) }
    status { :to_do }
  end
end
