# frozen_string_literal: true

class RetrieveGoalsStreakAction
  def initialize(user:, goals: [])
    @user = user
    @goals = goals
  end

  def call(today: DateTime.current.utc)
    ActiveRecord::Base.transaction do
      streaks = {}

      @goals.each do |goal|
        goal_id = goal.id
        # TODO: introduce caching for these queries with memcached or redis
        streak_count = RetrieveGoalStreakAction.new(user: @user, goal:).call(today:)
        streaks[goal_id] = streak_count
      end

      streaks
    end
  end
end
