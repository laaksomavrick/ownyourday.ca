# frozen_string_literal: true

class TodayController < ApplicationController
  def index
    @task_list = RetrieveTodaysTaskListAction.new(user: current_user).call
    @task_list ||= GenerateTodaysTaskListAction.new(user: current_user).call
    authorize @task_list
    @task_list
  end
end
