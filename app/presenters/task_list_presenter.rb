# frozen_string_literal: true

class TaskListPresenter
  def initialize(task_list:, streaks:)
    @task_list = task_list
    @streaks = streaks
  end

  def id
    @task_list.id
  end

  def tasks
    task_vms = @task_list.tasks.map do |task|
      goal_id = task.try(:goal).try(:id)
      streak = @streaks[goal_id]
      TaskViewModel.new(task:, streak:)
    end

    task_vms.sort_by { |vm| vm.task.position }
  end
end

class TaskViewModel
  attr_reader :task, :streak

  def initialize(task:, streak:)
    @task = task
    @streak = streak
  end
end
