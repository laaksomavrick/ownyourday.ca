# frozen_string_literal: true

FactoryBot.define do
  factory :milestone do
    goal factory: :daily_goal
    name { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    completed { true }
    completed_at { Faker::Date.between(from: 7.days.ago, to: Time.zone.today) }
  end
end
