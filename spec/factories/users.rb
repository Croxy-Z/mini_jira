# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { "password123" }
    role { :user }

    trait :manager do
      role { :manager }
    end

    trait :admin do
      role { :admin }
    end
  end
end
