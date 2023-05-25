# frozen_string_literal: true

class AdhocTasksController < ApplicationController
  def new
    @adhoc_task = AdhocTask.new
  end

  def create
    # TODO: get task list id from query param if possible
    # e.g. go to tomorrow to create a TODO - i do this sometimes

    # An ad hoc goal is always created for today's task list
    # So, retrieve that - if one does not exist, generate it
    # Usually it will exist since the button to hit 'new' is on the tasks index
    date = current_user.beginning_of_day
    task_list = RetrieveTodaysTaskListAction.new(user: current_user).call(today: date)
    task_list ||= GenerateTodaysTaskListAction.new(user: current_user).call(today: date)

    @adhoc_task = AdhocTask.create(adhoc_task_params.merge(task_list:))

    if @adhoc_task.errors.empty? == false
      render 'new', status: :unprocessable_entity
      return
    end

    flash[:notice] = t('helpers.alert.create_successful', name: @adhoc_task.name)
    redirect_to tasks_path
  end

  private

  def adhoc_task_params
    params.fetch(:adhoc_task, {}).permit(
      :user_id,
      :name
    )
  end
end
