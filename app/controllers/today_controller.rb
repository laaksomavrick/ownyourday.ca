# frozen_string_literal: true

class TodayController < ApplicationController
  def index
    # TODO: authorization
    # Confirm we're storing all dates in UTC - convert to user localized TZ when doing calcs for scheduling

    # If "todays tasks" exists for NOW localized to USER TZ
    # return todays tasks
    # otherwise, create "todays tasks"
    # For each goal
    # Determine whether the goal should be scheduled for today
    # If true, create a "task" record for the goal

    # daily_tasks = current_user.daily_goals
  end
end
