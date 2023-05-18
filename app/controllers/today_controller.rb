# frozen_string_literal: true

class TodayController < ApplicationController
  def index
    # TODO: authorization

    @task_list = RetrieveTodaysTaskListAction.new(user: current_user).call

    return unless @task_list.nil?

    @task_list = GenerateTodaysTaskListAction.new(user: current_user).call
  end
end
