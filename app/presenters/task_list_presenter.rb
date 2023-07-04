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
    task_vms = @task_list.tasks.map do |task|
      TaskPresenter.new(user: @user, task:).call
    end

    task_vms.sort_by { |vm| vm.task.position }
  end
end
