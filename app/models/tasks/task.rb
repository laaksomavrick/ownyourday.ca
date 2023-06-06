# frozen_string_literal: true

module Tasks
  class Task < ApplicationRecord
    self.table_name = 'tasks'

    belongs_to :user
    belongs_to :task_list

    acts_as_list scope: :task_list, top_of_list: 0

    validates :position, presence: true

    class << self
      def policy_class
        TaskPolicy
      end
    end
  end
end
