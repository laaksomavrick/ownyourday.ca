# frozen_string_literal: true

class RetrieveGoalsStreakAction
  def initialize(user:, goals: [])
    @user = user
    @goals = goals
  end

  def call
    user_today_date = @user.beginning_of_day
    streaks = {}

    @goals.each do |goal|
      goal_id = goal.id
      streak_count = case goal.type
                     when Goals::Daily.name
                       streak_for_daily_goal(goal:, task_list_date: user_today_date)
                     end

      streaks[goal_id] = streak_count
    end

    streaks
  end

  private

  def streak_for_daily_goal(goal:, task_list_date:)
    goal_id = goal.id
    last_uncompleted_task = find_last_uncompleted_task(goal_id:, task_list_date:)

    if last_uncompleted_task
      last_uncompleted_task_date = last_uncompleted_task.task_list.date
      streak_count = Tasks::GoalTask
                     .joins(:task_list)
                     .where(goal_id:, completed: true)
                     .where('task_lists.date > ?', last_uncompleted_task_date)
                     .count
    else
      streak_count = Tasks::GoalTask
                     .joins(:task_list)
                     .where(goal_id:, completed: true)
                     .count
    end

    streak_count
  end

  def find_last_uncompleted_task(goal_id:, task_list_date:)
    Tasks::GoalTask
      .joins(:task_list)
      .where(goal_id:, completed: false)
      .where.not(task_lists: { date: task_list_date })
      .order({ 'task_lists.date' => :desc })
      .limit(1)
      .first
  end
end
