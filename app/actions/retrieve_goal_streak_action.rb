# frozen_string_literal: true

class RetrieveGoalStreakAction
  def initialize(user:, goal:)
    @user = user
    @goal = goal
  end

  def call(today: DateTime.current.utc)
    user_today_date = @user.beginning_of_day(today:)

    # TODO: introduce caching for these queries with memcached or redis
    case @goal.type
    when Goals::Daily.name, Goals::DaysOfWeek.name
      streak_for_sequential_goal(goal: @goal, task_list_date: user_today_date)
    when Goals::TimesPerWeek.name
      streak_for_times_per_week_goal(goal: @goal, task_list_date: user_today_date)
    else
      raise "Goal type #{goal.type} not recognized"
    end
  end

  private

  # Completions in the current week plus every earlier consecutive week that met the goal
  def streak_for_times_per_week_goal(goal:, task_list_date:)
    tasks = goal_tasks_up_to(goal:, task_list_date:)
    first_task_list_date = tasks.minimum('task_lists.date')

    return 0 if first_task_list_date.nil?

    completions_by_week = tasks.where(completed: true)
                               .pluck('task_lists.date')
                               .map { |date| user_week(date) }
                               .tally

    current_week = user_week(task_list_date)
    first_week = user_week(first_task_list_date)
    streak_count = completions_by_week.fetch(current_week, 0)

    week = current_week - 7.days
    while week >= first_week
      completions = completions_by_week.fetch(week, 0)
      break if completions < goal.times_per_week

      streak_count += completions
      week -= 7.days
    end

    streak_count
  end

  # Completed tasks since the most recent uncompleted task. Today's task doesn't break the streak
  # until the day is over, and future task lists are ignored
  def streak_for_sequential_goal(goal:, task_list_date:)
    tasks = goal_tasks_up_to(goal:, task_list_date:)
    last_uncompleted_date = tasks.where(completed: false)
                                 .where(task_lists: { date: ...task_list_date })
                                 .maximum('task_lists.date')

    completed_tasks = tasks.where(completed: true)
    completed_tasks = completed_tasks.where('task_lists.date > ?', last_uncompleted_date) if last_uncompleted_date
    completed_tasks.count
  end

  def goal_tasks_up_to(goal:, task_list_date:)
    Tasks::GoalTask
      .joins(:task_list)
      .where(goal_id: goal.id)
      .where(task_lists: { date: ..task_list_date })
  end

  # Monday of the week the date falls in, in the user's time zone
  def user_week(date)
    date.in_time_zone(@user.time_zone).to_date.beginning_of_week
  end
end
