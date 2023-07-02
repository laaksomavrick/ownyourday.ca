# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    time_zone { 'UTC' }
    created_at { DateTime.current.utc.in_time_zone(time_zone) }
  end
end
