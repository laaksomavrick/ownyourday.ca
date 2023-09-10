# frozen_string_literal: true

module Goals
  class Goal < ApplicationRecord
    self.table_name = 'goals'
    GOAL_TYPES = %w[Goals::Daily Goals::TimesPerWeek Goals::DaysOfWeek].freeze

    belongs_to :user
    has_many :tasks, class_name: 'Tasks::GoalTask', dependent: :destroy
    has_many :milestones, dependent: :destroy

    validates :name, presence: true
    validates :type, inclusion: GOAL_TYPES
    validates :position, presence: true

    after_create :update_todays_task_list
    after_update :update_todays_task_list
    after_destroy :update_todays_task_list, prepend: true

    acts_as_list scope: :user, top_of_list: 0

    # rubocop:disable Naming/PredicateName
    def is_daily?
      type == Goals::Daily.name
    end

    def is_times_per_week?
      type == Goals::TimesPerWeek.name
    end

    def is_days_of_week?
      type == Goals::DaysOfWeek.name
    end
    # rubocop:enable Naming/PredicateName

    def active_milestone
      milestones.where(completed: false).first
    end

    def inactive_milestones
      milestones.where(completed: true).to_a
    end

    class << self
      def policy_class
        GoalPolicy
      end

      def goal_types
        GOAL_TYPES
      end
    end

    private

    def update_todays_task_list
      UpdateTodaysTaskListAction.new(goal: self).call
    end
  end
end
