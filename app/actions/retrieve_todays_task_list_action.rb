# frozen_string_literal: true

class RetrieveTodaysTaskListAction
  def initialize(user:)
    @user = user
  end

  def call(today: DateTime.current.utc)
    user_date = @user.beginning_of_day(today:)

    @user.task_lists
         .includes(tasks: :goal)
         .where(date: user_date)
         .first
  end
end
