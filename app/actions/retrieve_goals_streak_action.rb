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

  def find_goal_completions_per_week(goal_id:)
    start_date = @user.beginning_of_day(@user.created_at)
    end_date = @user.beginning_of_day
    user_id = @user.id

    # TODO: find first where completed != expected completed; find # of rows after then; multiply that by completions_expected (excluding this week)

    query = <<-SQL.squish
      SELECT * FROM (
        SELECT To_char(week_start, 'IYYY-IW') year_week FROM generate_series(:start_date, :end_date, '1 week'::interval)
      ) as year_weeks
      LEFT OUTER JOIN (
        SELECT To_char(tl.date, 'IYYY-IW') year_week, COUNT(completed) completed
        FROM  tasks inner join task_lists tl on tasks.task_list_id = tl.id
        WHERE tl.user_id = :user_id GROUP  BY year_week
      ) tasks
    ON year_weeks.year_week = tasks.year_week
    ORDER BY year_weeks.year_week desc
    SQL

    results = connection.execute(
      sanitize_sql_for_assignment([query, { start_date:, end_date:, user_id: }])
    )
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
