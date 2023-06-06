# frozen_string_literal: true

module Tasks
  class GoalTask < Tasks::Task
    belongs_to :goal, class_name: 'Goals::Goal'
    delegate :name, to: :goal
  end
end
