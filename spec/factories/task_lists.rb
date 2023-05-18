# frozen_string_literal: true

FactoryBot.define do
  factory :task_list do
    user factory: :user
    date { DateTime.current.utc.beginning_of_day }
  end
end
