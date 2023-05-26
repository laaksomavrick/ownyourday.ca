# frozen_string_literal: true

class AdhocTasksController < ApplicationController
  def new
    # TODO: authorize
    @adhoc_task = AdhocTask.new
  end

  def create
    # TODO: authorize
    @adhoc_task = AdhocTask.create(adhoc_task_params)

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
