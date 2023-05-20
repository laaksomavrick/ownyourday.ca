# frozen_string_literal: true

class RetrieveTodaysTaskListAction
  def initialize(user:)
    @user = user
  end

  def call(today: DateTime.current.utc)
    user_timezone = @user.time_zone
    user_today = today.in_time_zone(user_timezone)
    user_date = user_today.to_date

    @user.task_lists
         .includes(tasks: :goal)
         .where('DATE(date) = ?', user_date).first
  end
end
