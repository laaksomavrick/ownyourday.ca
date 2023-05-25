# frozen_string_literal: true

class TaskListPresenter
  def initialize(task_list:)
    @task_list = task_list
  end

  def tasks
    goal_tasks = @task_list.tasks
    adhoc_tasks = @task_list.adhoc_tasks

    goal_tasks + adhoc_tasks
  end
end
