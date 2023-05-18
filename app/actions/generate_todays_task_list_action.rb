# frozen_string_literal: true

class GenerateTodaysTaskListAction
  def initialize(user:)
    super
    @user = user
  end

  def call(today: DateTime.current.utc)
    # in a transaction
    # create a task list for today
    # create tasks for the task list based on user goals
    # For each goal
    # Determine whether the goal should be scheduled for today
    # If true, create a "task" record for the goal

    user_start_of_day = @user.beginning_of_today
  end
end
