# frozen_string_literal: true

class CreateAdhocTaskAction
  def call(adhoc_task_params:)
    task_list_id = adhoc_task_params[:task_list_id]
    last_position = Tasks::Task.where(task_list_id:).maximum(:position)
    position = last_position.nil? ? 0 : last_position + 1
    Tasks::AdhocTask.create(adhoc_task_params.merge(position:))
  end
end
