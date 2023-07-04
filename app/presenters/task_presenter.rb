# frozen_string_literal: true

class TaskPresenter
  def initialize(user:, task:)
    @user = user
    @task = task
  end

  def call
    goal = @task.try(:goal)
    streak = nil
    context = nil
    if goal
      streak = RetrieveGoalStreakAction.new(user: @user, goal:).call
      context = generate_context(task: @task)
    end
    TaskViewModel.new(task: @task, streak:, context:)
  end

  private

  def generate_context(task:)
    context = {}
    return context if task.try(:goal).try(:type) != Goals::TimesPerWeek.name

    completions_expected = task.goal.times_per_week

    start_of_week = DateTime.current.utc.monday
    end_of_week = DateTime.current.utc.sunday.beginning_of_day
    completions_this_week = Tasks::GoalTask
                            .joins(:task_list)
                            .where(goal_id: task.goal.id)
                            .where('task_lists.date >= ?', start_of_week)
                            .where('task_lists.date <= ?', end_of_week)
                            .where(completed: true)
                            .count

    context[:completions_expected] = completions_expected
    context[:completions_this_week] = completions_this_week
    context
  end
end

class TaskViewModel
  attr_reader :task, :streak, :context

  def initialize(task:, streak:, context:)
    @task = task
    @streak = streak
    @context = context
  end

  def show_streak?
    @task.try(:goal).present?
  end

  def show_context?
    task_type = @task.try(:goal).try(:type)

    return false if task_type.nil?

    @task.goal.type == Goals::TimesPerWeek.name
  end
end
