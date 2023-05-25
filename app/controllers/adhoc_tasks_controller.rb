# frozen_string_literal: true

class AdhocTasksController < ApplicationController
  def new
    @adhoc_task = Task.new
  end

  def create
    # An ad hoc goal is always created for today's task list
    # So, retrieve that - if one does not exist, generate it
    # Usually it will exist since the button to hit 'new' is on the tasks index
    date = current_user.beginning_of_day
    task_list = RetrieveTodaysTaskListAction.new(user: current_user).call(today: date)
    task_list ||= GenerateTodaysTaskListAction.new(user: current_user).call(today: date)
  end
end
