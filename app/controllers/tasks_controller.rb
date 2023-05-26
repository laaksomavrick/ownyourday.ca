# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    # TODO: goal completion
    # TODO: goal ordering

    if params[:task_list_id].nil?
      @date = date_from_params || current_user.beginning_of_day
      task_list = task_list_from_date(date: @date)
    else
      task_list = task_list_from_id(id: params[:task_list_id])

      if task_list.nil?
        redirect_to tasks_path
        return
      end

      @date = task_list.date
    end

    authorize task_list

    @task_list = TaskListPresenter.new(task_list:)
  end

  private

  def task_list_from_date(date:)
    task_list = RetrieveTodaysTaskListAction.new(user: current_user).call(today: :date)
    task_list ||= GenerateTodaysTaskListAction.new(user: current_user).call(today: :date)
    task_list
  end

  def task_list_from_id(id:)
    TaskList
      .with_tasks
      .where(id:)
      .first
  end

  def tasks_params
    params.fetch(:task_list, {}).permit(
      'date(1i)',
      'date(2i)',
      'date(3i)'
    )
  end

  def date_from_params
    year = tasks_params['date(1i)'].to_i
    month = tasks_params['date(2i)'].to_i
    date = tasks_params['date(3i)'].to_i

    return nil if year.zero? || month.zero? || date.zero?

    Date.new(year, month, date)
  end
end
