# frozen_string_literal: true

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

      raise ActiveRecord::Rollback if task_lists.count.zero?

      task_lists.each do |task_list|
        goal_task_data = task_list.goal_tasks.map do |goal_task|
          { goal_id: goal_task.goal_id, completed: goal_task.completed }
        end
        adhoc_task_ids = task_list.adhoc_tasks.map(&:id)

        task_list.destroy

        task_list = GenerateTodaysTaskListAction.new(user:).call

        add_adhoc_tasks(task_list, adhoc_task_ids)
        complete_goal_tasks(task_list, goal_task_data)
        normalize_goal_positions(task_list)
      end
    end
  end

  private

  def normalize_goal_positions(task_list)
    task_list.tasks.order(position: :asc).each_with_index do |task, index|
      task.insert_at(index)
    end
  end

  def add_adhoc_tasks(task_list, adhoc_task_ids)
    # rubocop:disable Rails/SkipsModelValidations
    Tasks::AdhocTask.where(id: adhoc_task_ids).update_all(task_list_id: task_list.id)
    # rubocop:enable Rails/SkipsModelValidations
  end

  def complete_goal_tasks(task_list, goal_task_data)
    goal_task_ids_to_complete = []
    task_list.tasks.each do |task|
      match = goal_task_data.find { |goal_task| goal_task[:goal_id] == task.goal_id }
      next if match.blank?

      completed = match[:completed]
      goal_id = match[:goal_id]
      goal_task_ids_to_complete.push(goal_id) if completed
    end

    # rubocop:disable Rails/SkipsModelValidations
    Tasks::GoalTask.where(goal_id: goal_task_ids_to_complete).update_all(completed: true)
    # rubocop:enable Rails/SkipsModelValidations
  end
end
