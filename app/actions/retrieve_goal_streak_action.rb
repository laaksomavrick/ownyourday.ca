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

  def streak_for_times_per_week_goal(goal:, task_list_date:)
    goal_id = goal.id
    last_failed_week = find_most_recent_days_per_week_failure(goal:, task_list_date:)

    if last_failed_week.count.zero?
      streak_count = Tasks::GoalTask
                     .joins(:task_list)
                     .where(goal_id:, completed: true)
                     .count
    else
      week_end = last_failed_week[0]['week_end']
      streak_count = Tasks::GoalTask
                     .joins(:task_list)
                     .where(goal_id:, completed: true)
                     .where('task_lists.date >= ?', week_end)
                     .count
    end

    streak_count
  end

  def streak_for_sequential_goal(goal:, task_list_date:)
    goal_id = goal.id
    last_uncompleted_task = find_most_recent_uncompleted_task(goal_id:, task_list_date:)

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

  def find_most_recent_days_per_week_failure(goal:, task_list_date:)
    start_date = @user.beginning_of_day(today: @user.created_at).monday
    end_date = @user.beginning_of_day.sunday
    user_id = @user.id
    times_per_week = goal.times_per_week

    query = <<-SQL.squish
      SELECT * FROM (
        SELECT
          week_start,
          week_start + interval '7 days' as week_end,
          To_char(week_start, 'IYYY-IW') year_week
        FROM generate_series(:start_date, :end_date, '1 week'::interval)
          AS week_start
      ) as year_weeks
      LEFT OUTER JOIN (
        SELECT
          To_char(tl.date, 'IYYY-IW') year_week,
          COUNT(completed) completed_tasks_that_week
        FROM  tasks inner join task_lists tl on tasks.task_list_id = tl.id
        WHERE tl.user_id = :user_id
        AND completed = true
        GROUP  BY year_week
      ) tasks
      ON year_weeks.year_week = tasks.year_week
      WHERE completed_tasks_that_week != :times_per_week
      AND year_weeks.week_end < :task_list_date::DATE
      ORDER BY year_weeks.year_week desc
    SQL

    ActiveRecord::Base.connection.execute(
      ActiveRecord::Base.sanitize_sql([query, { start_date:, end_date:, user_id:, times_per_week:, task_list_date: }])
    )
  end

  def find_most_recent_uncompleted_task(goal_id:, task_list_date:)
    Tasks::GoalTask
      .joins(:task_list)
      .where(goal_id:, completed: false)
      .where.not(task_lists: { date: task_list_date })
      .order({ 'task_lists.date' => :desc })
      .limit(1)
      .first
  end
end
