# frozen_string_literal: true

class UpdateGoalAction
  def initialize(goal)
    @goal = goal
  end

  def call(updates = {}, opts = {})
    persist = opts[:persist] || false # TODO: opts.try(:persist, false)

    should_update_type = updates[:type].present?

    @goal = update_type(@goal, updates[:type]) if should_update_type

    should_update_times_per_week = updates[:times_per_week].present? && @goal.is_times_per_week?
    should_update_days_of_week = updates[:days_of_week].present? && @goal.is_days_of_week?

    @goal.name = updates[:name] if updates[:name]
    @goal.user_id = updates[:user_id] if updates[:user_id]

    @goal = update_times_per_week(@goal, updates[:times_per_week]) if should_update_times_per_week
    @goal = update_days_of_week(@goal, updates[:days_of_week]) if should_update_days_of_week

    @goal.save if persist

    @goal
  end

  private

  def update_type(goal, type)
    type = type.constantize
    goal = goal.becomes(type)
    goal.type = type
    case goal.type
    when Goals::Daily.name
      goal.metadata = Goals::Daily::DEFAULT_SCHEDULE
    when Goals::TimesPerWeek.name
      goal.times_per_week = Goals::TimesPerWeek::DEFAULT_SCHEDULE
    when Goals::DaysOfWeek.name
      goal.days_of_week = Goals::DaysOfWeek::DEFAULT_SCHEDULE
    else
      raise "Unknown type when updating goal type=#{goal.type}"
    end

    goal
  end

  def update_times_per_week(goal, times_per_week)
    goal.times_per_week = times_per_week
    goal
  end

  def update_days_of_week(goal, days_of_week)
    days_of_week_keys = days_of_week.keys.map(&:to_s)
    days_of_week = days_of_week_keys.filter { |day| days_of_week[day] == '1' }
    goal.days_of_week = days_of_week
    goal
  end
end
