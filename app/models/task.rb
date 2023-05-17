# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  belongs_to :goal, class_name: 'Goals::Goal'
  belongs_to :task_list
end
