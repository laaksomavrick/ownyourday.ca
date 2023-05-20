# frozen_string_literal: true

FactoryBot.define do
  factory :task_list do
    user factory: :user
    date { DateTime.current }
  end
end
