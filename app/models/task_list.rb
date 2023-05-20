# frozen_string_literal: true

class TaskList < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :nullify

  validate :date, :validate_date

  before_validation :default_values

  private

  def validate_date
    user_timezone = user.time_zone
    start_of_day = date.utc.in_time_zone(user_timezone).beginning_of_day.utc

    is_valid = start_of_day == date

    errors.add(:date, 'must be the start of the day') unless is_valid
  end

  def default_values
    date = self.date || DateTime.current
    self.date = date.utc.in_time_zone(user.time_zone).beginning_of_day.utc
  end

  class << self
    def policy_class
      TaskListPolicy
    end
  end
end
