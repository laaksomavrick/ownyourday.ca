FactoryBot.define do
  factory :milestone do
    goal factory: :daily_goal
    name { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    completed { true }
  end
end
