# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { 'password' }
    time_zone { 'UTC' }
    created_at { DateTime.current.utc.in_time_zone(time_zone) }
  end
end
