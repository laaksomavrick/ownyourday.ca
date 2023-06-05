# frozen_string_literal: true

class TaskListPresenter
  def initialize(task_list:)
    @task_list = task_list
  end

  def id
    @task_list.id
  end

  def tasks
    goal_tasks = @task_list.tasks
    adhoc_tasks = @task_list.adhoc_tasks

    tasks = goal_tasks + adhoc_tasks
    tasks.sort_by(&:position)
  end
end
