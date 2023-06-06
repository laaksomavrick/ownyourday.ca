# frozen_string_literal: true

class AdhocTasksController < ApplicationController
  def new
    @adhoc_task = authorize Tasks::AdhocTask.new
  end

  def create
    # TODO: create action + test
    task_list_id = adhoc_task_params[:task_list_id]
    position = TaskList.where(id: task_list_id).includes(:tasks).count(:tasks)

    @adhoc_task = authorize Tasks::AdhocTask.create(adhoc_task_params.merge(position:))

    if @adhoc_task.errors.empty? == false
      render 'new', status: :unprocessable_entity
      return
    end

    flash[:notice] = t('helpers.alert.create_successful', name: @adhoc_task.name)
    redirect_to tasks_path(task_list_id: @adhoc_task.task_list_id)
  end

  private

  def adhoc_task_params
    params.fetch(:adhoc_task, {}).permit(
      :user_id,
      :name,
      :task_list_id
    )
  end
end
