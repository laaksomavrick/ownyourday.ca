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
    streaks = generate_streaks
    task_vms = @task_list.tasks.map do |task|
      goal_id = task.try(:goal).try(:id)
      streak = streaks[goal_id]
      TaskViewModel.new(task:, streak:)
    end

    task_vms.sort_by { |vm| vm.task.position }
  end

  private

  def generate_streaks
    goals = @user.goals
    RetrieveGoalsStreakAction.new(user: @user, goals:).call
  end
end

class TaskViewModel
  attr_reader :task, :streak

  def initialize(task:, streak:)
    @task = task
    @streak = streak
  end
end
