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

  # Completed days counting back from today. A day the goal was due breaks the streak if its task
  # wasn't completed, or if there's no task because the app wasn't opened that day. Today's task
  # doesn't break the streak until the day is over, and future task lists are ignored
  def streak_for_sequential_goal(goal:, task_list_date:)
    tasks = goal_tasks_up_to(goal:, task_list_date:)
    completed_by_day = tasks.pluck('task_lists.date', :completed)
                            .to_h { |date, completed| [user_day(date), completed] }

    today = user_day(task_list_date)
    first_day = [user_day(goal.created_at), *completed_by_day.keys].min
    streak_count = completed_by_day[today] ? 1 : 0

    day = today - 1.day
    while day >= first_day
      completed = completed_by_day[day]
      break if completed == false || (completed.nil? && goal.scheduled_on?(day))

      streak_count += 1 if completed
      day -= 1.day
    end

    streak_count
  end

  def goal_tasks_up_to(goal:, task_list_date:)
    Tasks::GoalTask
      .joins(:task_list)
      .where(goal_id: goal.id)
      .where(task_lists: { date: ..task_list_date })
  end

  def user_day(date)
    date.in_time_zone(@user.time_zone).to_date
  end

  # Monday of the week the date falls in, in the user's time zone
  def user_week(date)
    user_day(date).beginning_of_week
  end
end
