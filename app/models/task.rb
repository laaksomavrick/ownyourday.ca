# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  belongs_to :goal, class_name: 'Goals::Goal'
  belongs_to :task_list

  delegate :name, to: :goal

  acts_as_list top_of_list: 0

  default_scope { order(position: :asc) }

  class << self
    def policy_class
      TaskPolicy
    end
  end
end
