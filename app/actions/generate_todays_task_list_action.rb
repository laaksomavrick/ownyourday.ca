# frozen_string_literal: true

class GenerateTodaysTaskListAction
  def initialize(user:)
    @user = user
  end

  def call(today: DateTime.current.utc)
    TaskList.transaction do
      task_list_date = today.beginning_of_day
      task_list = TaskList.create(user: @user, date: task_list_date)

      daily_tasks = daily_goals_to_schedule(task_list:)

      tasks = daily_tasks

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
end
