# frozen_string_literal: true

class TaskListPresenter
  def initialize(task_list:)
    @task_list = task_list
  end

  def id
    @task_list.id
  end

  def tasks
    @task_list.tasks.sort_by(&:position)
  end
end
