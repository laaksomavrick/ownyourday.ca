# frozen_string_literal: true

# For every task list from today and beyond:
# Null adhoc-task task_list_id
# Maintain goal completions and goal positions
# Generate new task list
# Remove the prior task list
# Complete goals that were previously completed
# Add adhhoc-tasks back
# Normalize position for any additions or removals

# Intended to regenerate the existing (and any future) "today's task list" for a
# user when a goal has been added, changed, or deleted
# Prior task lists won't be affected
class UpdateTodaysTaskListAction
  def initialize(goal:)
    @goal = goal
  end

  def call
    ActiveRecord::Base.transaction do
      user = @goal.user
      date = user.beginning_of_day

      task_lists = TaskList.where(user:).where('date >= ?', date).all

      raise "No task list found for user=#{user.id}" if task_lists.count.zero?

      task_lists.each do |task_list|
        goal_tasks = task_list.goal_tasks
        adhoc_tasks = task_list.adhoc_tasks

        task_list.destroy

        task_list = GenerateTodaysTaskListAction.new(user:).call

        adhoc_tasks.update_all(task_list_id: task_list.id)
        # goal_tasks.update_all(task_list_id: task_list.id)

        # TODO: mass update for performance reasons
        # goal_tasks.tasks.each do |task|
        # matching_task = tasks.find_by(id: task.id)
        # if matching_task
        #   if matching_task.completed
        #     task.completed = matching_task.completed
        #     task.save
        #   end
        # end
        # end
      end
    end
  end
end
