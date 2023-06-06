# frozen_string_literal: true

FactoryBot.define do
  factory :goal_task, class: 'Tasks::GoalTask' do
    user factory: :user
    goal factory: :daily_goal
    task_list factory: :task_list
    position { 0 }
  end
end
