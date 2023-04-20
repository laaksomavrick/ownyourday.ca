# frozen_string_literal: true

FactoryBot.define do
  factory :goal do
    user factory: :user
    name { Faker::Lorem.word }
  end
end
