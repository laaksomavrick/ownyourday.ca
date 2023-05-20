# frozen_string_literal: true

class GenerateTodaysTaskListAction
  def initialize(user:)
    @user = user
  end

  def call(today: DateTime.current.utc)
    TaskList.transaction do
      user_timezone = @user.time_zone
      user_today = today.in_time_zone(user_timezone)
      user_date = user_today.beginning_of_day.utc

      task_list = TaskList.create(user: @user, date: user_date)

      daily_tasks = daily_goals_to_schedule(task_list:)
      day_of_week_tasks = days_of_week_goals_to_schedule(task_list:, today:)
      times_per_week_tasks = times_per_week_goals_to_schedule(task_list:, today:)

      tasks = daily_tasks + day_of_week_tasks + times_per_week_tasks

      Task.create!(tasks)

      task_list
    end
  end

  private

  def daily_goals_to_schedule(task_list:)
    daily_goals = @user.daily_goals
    daily_goals.map do |daily_goal|
      { user: @user, goal: daily_goal, task_list: }
    end
  end

  def days_of_week_goals_to_schedule(task_list:, today:)
    current_day_of_week = (today.wday + 6) % 7 # Monday is our 0 instead of Sunday
    days_of_week_goals = @user.days_of_week_goals
    days_of_week_goals
      .filter { |day_of_week_goal| day_of_week_goal.days_of_week.include?(current_day_of_week) }
      .map { |day_of_week_goal| { user: @user, goal: day_of_week_goal, task_list: } }
  end

  def times_per_week_goals_to_schedule(task_list:, today:)
    start_of_week = today.beginning_of_week
    end_of_week = today.end_of_week.beginning_of_day

    times_per_week_goals = @user.times_per_week_goals
    times_per_week_goal_ids = times_per_week_goals.select(:id)

    completed_tasks = Task.joins(:task_list)
                          .where('task_lists.date >= ?', start_of_week)
                          .where('task_lists.date <= ?', end_of_week)
                          .where(goal_id: times_per_week_goal_ids)
                          .where(completed: true)
                          .all

    # rubocop:disable Style/MultilineBlockChain
    times_per_week_goals
      .filter do |times_per_week_goal|
        completed_tasks.where(goal_id: times_per_week_goal.id).count < times_per_week_goal.times_per_week
      end
      .map { |times_per_week_goal| { user: @user, goal: times_per_week_goal, task_list: } }
    # rubocop:enable Style/MultilineBlockChain
  end
end
