# frozen_string_literal: true

class TaskPositionController < ApplicationController
  def update
    id = task_position_update_params[:id]
    position = task_position_update_params[:position].to_i
    type = task_position_update_params[:type].constantize

    unless [AdhocTask, Task].include?(type)
      head :bad_request
      return
    end

    @task = authorize type.find_by(id:)
    authorize @task

    if @task.nil?
      head :not_found
      return
    end

    @task.insert_at(position)
    @task.save

    if @task.errors.empty? == false
      flash.now[:alert] = t('helpers.alert.update_failed', name: @task.name)
      head :unprocessable_entity
      return
    end

    head :ok
  end

  private

  def task_position_update_params
    params.require(:position)
    params.require(:id)
    params.require(:type)
    params.permit(:position, :id, :type)
  end
end
