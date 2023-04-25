# frozen_string_literal: true

module Goals
  class ScheduleComponent < ViewComponent::Base
    def initialize(goal:)
      super
      @goal = goal
    end

    def is_daily?
      @goal.type == Goals::Daily.name
    end

    def is_times_per_week?
      @goal.type == Goals::TimesPerWeek.name
    end

    def is_days_of_week?
      @goal.type == Goals::DaysOfWeek.name
    end

    def goal_type_radios
      [
        {
          label: I18n.t('goal.schedule.daily_label'),
          value: Goals::Daily.name
        },
        {
          label: I18n.t('goal.schedule.times_per_week_label'),
          value: Goals::TimesPerWeek.name
        },
        {
          label: I18n.t('goal.schedule.days_of_week_label'),
          value: Goals::DaysOfWeek.name
        }
      ]
    end
  end
end
