# frozen_string_literal: true

FactoryBot.define do
  factory :days_of_week_goal, class: 'Goals::DaysOfWeek' do
    user factory: :user
    name { Faker::Lorem.word }
    type { Goals::DaysOfWeek.name }
    metadata { { 'days_of_week' => Goals::DaysOfWeek::DEFAULT_SCHEDULE } }
  end
end
