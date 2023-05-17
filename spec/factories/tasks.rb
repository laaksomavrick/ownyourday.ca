# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    user factory: :user
    goal factory: :daily_goal
    task_list factory: :task_list
  end
end
