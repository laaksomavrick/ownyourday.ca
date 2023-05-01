# frozen_string_literal: true

FactoryBot.define do
  factory :times_per_week_goal, class: 'Goals::TimesPerWeek' do
    user factory: :user
    name { Faker::Lorem.word }
    type { Goals::TimesPerWeek.name }
    metadata { { 'times_per_week' => 1 } }
  end
end
