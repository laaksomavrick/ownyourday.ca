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
        goal_task_data = task_list.goal_tasks.map do |goal_task|
          { goal_id: goal_task.goal_id, completed: goal_task.completed }
        end
        adhoc_task_ids = task_list.adhoc_tasks.map(&:id)

        task_list.destroy

        task_list = GenerateTodaysTaskListAction.new(user:).call

        # Re-add ad-hoc tasks
        Tasks::AdhocTask.where(id: adhoc_task_ids).update_all(task_list_id: task_list.id)

        # Complete previously completed goal tasks
        goal_task_ids_to_complete = []
        task_list.tasks.each do |task|
          match = goal_task_data.find { |goal_task| goal_task[:goal_id] == task.goal_id }
          next if match.blank?

          completed = match[:completed]
          goal_id = match[:goal_id]
          goal_task_ids_to_complete.push(goal_id) if completed
        end

        Tasks::GoalTask.where(goal_id: goal_task_ids_to_complete).update_all(completed: true)

        # Normalize position
        task_list.tasks.order(position: :asc).each_with_index do |task, index|
          task.insert_at(index)
        end
      end
    end
  end
end
