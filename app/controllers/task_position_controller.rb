# frozen_string_literal: true

class TaskPositionController < ApplicationController
  def update
    id = params[:id]
    position = task_position_update_params[:position].to_i
    type = task_position_update_params[:type].constantize

    unless [Tasks::AdhocTask, Tasks::GoalTask].include?(type)
      flash.now[:alert] = t('helpers.alert.update_failed', name: @task.name)
      render 'update', status: :unprocessable_entity
      return
    end

    @task = authorize Tasks::Task.find_by(id:)
    @task.insert_at(position)

    task_list = @task.task_list
    @task_list = TaskListPresenter.new(user: current_user, task_list:)

    flash.now[:alert] = t('helpers.alert.update_failed', name: @task.name) if @task.errors.empty? == false
  end

  private

  def task_position_update_params
    params.require(:id)
    params.require(:task_position).tap do |task_position_params|
      task_position_params.require(:position)
      task_position_params.require(:type)
    end
  end
end
