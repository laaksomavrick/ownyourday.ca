# frozen_string_literal: true

FactoryBot.define do
  factory :adhoc_task, class: 'Tasks::AdhocTask' do
    user factory: :user
    task_list factory: :task_list
    name { Faker::Lorem.word }
    position { 0 }
  end
end
