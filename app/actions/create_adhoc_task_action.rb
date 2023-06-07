# frozen_string_literal: true

class CreateAdhocTaskAction
  def call(adhoc_task_params:)
    task_list_id = adhoc_task_params[:task_list_id]
    position = TaskList.where(id: task_list_id).includes(:tasks).count(:tasks)
    Tasks::AdhocTask.create(adhoc_task_params.merge(position:))
  end
end
