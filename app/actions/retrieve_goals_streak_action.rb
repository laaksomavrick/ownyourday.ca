# frozen_string_literal: true

class RetrieveGoalsStreakAction
  def initialize(user:, goal_ids: [])
    @user = user
    @goal_ids = goal_ids
  end

  def call
    # For the given goal_ids (e.g., what's being rendered in today's goals)
    # - Find LIMIT(1) task where where goal_id = $GOAL_ID and user_id = $USER_ID and completion = false ordered by task_list.date DESC
    # - If no false completion, streak is count of tasks where goal_id = $GOAL_ID and user_id = $USER_ID
    # - If false completion, streak is count of all tasks where goal_id = $GOAL_ID and user_id = $USER_ID and date > $FOUND_UNCOMPLETE_TASK_DATE

    user_today_date = @user.beginning_of_day
    streaks = {}

    # TODO: way to optimize this to reduce query load?
    @goal_ids.each do |goal_id|
      last_uncompleted_task = Tasks::GoalTask
                              .joins(:task_list)
                              .where(goal_id:, completed: false)
                              .where.not(task_lists: { date: user_today_date })
                              .order({ 'task_lists.date' => :desc })
                              .limit(1)
                              .first
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
                       .where(goal_id:)
                       .where.not(task_lists: { date: user_today_date })
                       .count
      end

      streaks[goal_id] = streak_count
    end

    streaks
  end
end
