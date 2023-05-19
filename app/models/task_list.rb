# frozen_string_literal: true

class TaskList < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :nullify

  validate :date, :validate_date

  private

  def validate_date
    start_of_day = date.utc.beginning_of_day
    is_valid = start_of_day == date

    errors.add(:date, 'must be the start of the day') unless is_valid
  end

  class << self
    def policy_class
      TaskListPolicy
    end
  end
end
