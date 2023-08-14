# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    hash = task_list_and_date_from_params
    task_list = hash[:task_list]
    date = hash[:date]

    if task_list.nil?
      redirect_to tasks_path
      return
    end

    authorize task_list

    @task_list = TaskListPresenter.new(user: current_user, task_list:)
    @date = date
  end

  def update
    id = params[:id]
    completed = task_update_params[:completed]

    @task = authorize Tasks::Task.find_by(id:)
    @task.completed = completed

    @task.save
    @vm = TaskPresenter.new(user: current_user, task: @task).call

    return unless @task.errors.empty? == false

    flash.now[:alert] = t('helpers.alert.update_failed', name: @task.name)
    render 'index', status: :unprocessable_entity
  end

  private

  def task_update_params
    params.require(:task).permit(:completed).tap do |task_params|
      task_params.require(:completed)
    end
  end

  def task_list_and_date_from_params
    hash = {}

    if params[:task_list_id].nil?
      date = date_from_params.try(:utc) || DateTime.current.utc.beginning_of_day
      user_date = date_from_params || current_user.beginning_of_day
      hash[:task_list] = task_list_from_date(date:)
      hash[:date] = date
      hash[:user_date] = user_date
    else
      task_list = task_list_from_id(id: params[:task_list_id])

      hash[:task_list] = task_list
      hash[:date] = current_user.beginning_of_day(today: task_list.date) if task_list
    end

    hash
  end

  def task_list_from_date(date:)
    task_list = RetrieveTodaysTaskListAction.new(user: current_user).call(today: date)
    task_list ||= GenerateTodaysTaskListAction.new(user: current_user).call(today: date)
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

    user_tz = current_user.time_zone

    DateTime.new(year, month, date).in_time_zone(user_tz)
  end
end
