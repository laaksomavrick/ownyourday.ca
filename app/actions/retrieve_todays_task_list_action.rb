# frozen_string_literal: true

class RetrieveTodaysTaskListAction
  def initialize(user:)
    @user = user
  end

  def call(today: DateTime.current.utc)
    @user.task_lists
         .with_tasks
         .where(date: today)
         .first
  end
end
