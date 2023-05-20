# frozen_string_literal: true

class TodayController < ApplicationController
  def index
    # TODO: rethink route (e.g. /tasks?date=...)

    # TODO: support choosing date
    # TODO: support ad-hoc goal
    # TODO: support goal completion
    @task_list = RetrieveTodaysTaskListAction.new(user: current_user).call
    @task_list ||= GenerateTodaysTaskListAction.new(user: current_user).call
    authorize @task_list
    @task_list
  end
end
