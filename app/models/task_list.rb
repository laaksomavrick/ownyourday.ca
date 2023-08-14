# frozen_string_literal: true

class TaskList < ApplicationRecord
  belongs_to :user
  has_many :tasks, -> { order(position: :asc) }, class_name: 'Tasks::Task', dependent: :nullify, inverse_of: :task_list
  has_many :goal_tasks, class_name: 'Tasks::GoalTask', dependent: :nullify
  has_many :adhoc_tasks, class_name: 'Tasks::AdhocTask', dependent: :nullify

  # TODO: validate
  # validate :date, :validate_date
  # before_validation :default_values

  scope :with_tasks, lambda {
    includes(goal_tasks: :goal).includes(:adhoc_tasks)
  }

  # def validate_date
  #   start_of_day = DateTime.current.utc.beginning_of_day
  #
  #   is_valid = start_of_day == date
  #
  #   errors.add(:date, 'must be the start of the day') unless is_valid
  # end

  # def default_values
  #   self.date = DateTime.current.utc.beginning_of_day
  # end

  class << self
    def policy_class
      TaskListPolicy
    end
  end
end
