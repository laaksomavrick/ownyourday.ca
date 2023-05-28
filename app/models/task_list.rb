# frozen_string_literal: true

class TaskList < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :nullify
  has_many :adhoc_tasks, dependent: :nullify

  validate :date, :validate_date

  before_validation :default_values

  scope :with_tasks, lambda {
    includes(tasks: :goal).includes(:adhoc_tasks)
  }

  private

  def validate_date
    start_of_day = user.beginning_of_day(today: date)

    is_valid = start_of_day == date

    errors.add(:date, 'must be the start of the day') unless is_valid
  end

  def default_values
    self.date = user.beginning_of_day(today: date)
  end

  class << self
    def policy_class
      TaskListPolicy
    end
  end
end
