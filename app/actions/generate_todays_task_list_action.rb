# frozen_string_literal: true

class GenerateTodaysTaskListAction
  def initialize(user:)
    @user = user
  end

  def call(today: DateTime.current.utc)
    TaskList.transaction do
      # TODO: We need to account for user tz here
      # e.g. 2am UTC but 10pm in -0400 - we would create duplicate
      # e.g. 10pm UTC but 2am in +0400 - we would create duplicate
      task_list_date = today.beginning_of_day
      task_list = TaskList.create(user: @user, date: task_list_date)

      daily_tasks = daily_goals_to_schedule(task_list:)
      day_of_week_tasks = days_of_week_goals_to_schedule(task_list:, today:)

      tasks = daily_tasks + day_of_week_tasks

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
end
