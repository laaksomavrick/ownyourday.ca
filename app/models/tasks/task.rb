# frozen_string_literal: true

module Tasks
  class Task < ApplicationRecord
    self.table_name = 'tasks'

    belongs_to :user
    belongs_to :task_list

    acts_as_list scope: :task_list, top_of_list: 0

    validates :position, presence: true

    # Moves the task to a zero-based index in its task list. The whole list is renumbered because
    # older task lists can have gaps in their positions
    def move_to(index)
      tasks = task_list.tasks.reorder(:position, :id).to_a
      tasks.delete(self)
      tasks.insert(index.clamp(0, tasks.length), self)

      task_list.renumber_task_positions(tasks)
    end

    class << self
      def policy_class
        TaskPolicy
      end
    end
  end
end
