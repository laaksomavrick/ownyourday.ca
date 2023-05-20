# frozen_string_literal: true

class RetrieveTodaysTaskListAction
  def initialize(user:)
    @user = user
  end

  def call(today: DateTime.current.utc)
    user_timezone = @user.time_zone
    user_today = today.in_time_zone(user_timezone)
    user_date = user_today.beginning_of_day.utc

    @user.task_lists
         .includes(tasks: :goal)
         .where(date: user_date)
         .first
  end
end
