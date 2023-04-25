# frozen_string_literal: true

module Goals
  class Goal < ApplicationRecord
    self.table_name = 'goals'

    belongs_to :user

    # TODO: better way to do this?
    GOAL_TYPES = %w[Goals::Daily Goals::TimesPerWeek Goals::DaysOfWeek].freeze

    validates :name, presence: true
    validates :type, inclusion: GOAL_TYPES

    def is_daily?
      type == Goals::Daily.name
    end

    def is_times_per_week?
      type == Goals::TimesPerWeek.name
    end

    def is_days_of_week?
      type == Goals::DaysOfWeek.name
    end

    class << self
      def policy_class
        GoalPolicy
      end

      def goal_types
        GOAL_TYPES
      end
    end
  end
end
