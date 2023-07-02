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
                     when Goals::TimesPerWeek.name
                       streak_for_times_per_week_goal(goal:, task_list_date: user_today_date)
                     end

      streaks[goal_id] = streak_count
    end

    streaks
  end

  private

  def streak_for_times_per_week_goal(goal:, task_list_date:)
    goal_id = goal.id
    # TODO: completions this week
    last_failed_week = find_most_recent_days_per_week_failure(goal:, task_list_date:)

    if last_failed_week.count.zero?
      streak_count = Tasks::GoalTask
                     .joins(:task_list)
                     .where(goal_id:, completed: true)
                     .count
    else
      completions_this_week = 0
      streak_count = Tasks::GoalTask
                     .joins(:task_list)
                     .where(goal_id:, completed: true)
                     .where('task_lists.date > ?', last_failed_week.week_end)
                     .count
      streak_count += completions_this_week
    end

    streak_count
  end

  def streak_for_daily_goal(goal:, task_list_date:)
    goal_id = goal.id
    last_uncompleted_task = find_last_uncompleted_daily_task(goal_id:, task_list_date:)

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
    # exclude_this_week = opts[:exclude_this_week] || false

    start_date = @user.beginning_of_day(today: @user.created_at)
    end_date = @user.beginning_of_day
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
        SELECT To_char(tl.date, 'IYYY-IW') year_week, COUNT(completed) completed_tasks_that_week
        FROM  tasks inner join task_lists tl on tasks.task_list_id = tl.id
        WHERE tl.user_id = :user_id GROUP  BY year_week
      ) tasks
    ON year_weeks.year_week = tasks.year_week
    WHERE completed_tasks_that_week != :times_per_week
    AND year_weeks.week_start < :task_list_date
    ORDER BY year_weeks.year_week desc
    SQL

    results = ActiveRecord::Base.connection.execute(
      ActiveRecord::Base.sanitize_sql([query, { start_date:, end_date:, user_id:, times_per_week:, task_list_date: }])
    )
  end

  def find_last_uncompleted_daily_task(goal_id:, task_list_date:)
    Tasks::GoalTask
      .joins(:task_list)
      .where(goal_id:, completed: false)
      .where.not(task_lists: { date: task_list_date })
      .order({ 'task_lists.date' => :desc })
      .limit(1)
      .first
  end
end
