# frozen_string_literal: true

FactoryBot.define do
  factory :daily_goal, class: 'Goals::Daily' do
    user factory: :user
    name { Faker::Lorem.word }
    type { Goals::Daily.name }
    position { 0 }
  end
end
