# frozen_string_literal: true

class TaskListPresenter
  def initialize(user:, task_list:)
    @user = user
    @task_list = task_list
  end

  def id
    @task_list.id
  end

  def tasks
    # TODO: join goals here to preload the association
    streaks = generate_streaks
    task_vms = @task_list.tasks.map do |task|
      goal_id = task.try(:goal).try(:id)
      streak = streaks[goal_id]
      context = generate_context(task:)
      TaskViewModel.new(task:, streak:, context:)
    end

    task_vms.sort_by { |vm| vm.task.position }
  end

  private

  def generate_streaks
    goals = @user.goals
    RetrieveGoalsStreakAction.new(user: @user, goals:).call
  end

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

  def show_context?
    @task.goal.type == Goals::TimesPerWeek.name
  end
end
