# frozen_string_literal: true

module Goals
  class DaysOfWeek < Goals::Goal
    store_accessor :metadata, :days_of_week
    validate :metadata, :validate_metadata

    private

    def validate_metadata
      days_of_week = metadata['days_of_week'].to_a
      has_days_of_week_integers = days_of_week.all? { |x| x >= 0 && x <= 6 }
      has_no_duplicates = days_of_week.length == days_of_week.uniq.length
      has_entries = !days_of_week.empty?

      errors.add(:days_of_week, 'has invalid days') unless has_days_of_week_integers

      errors.add(:days_of_week, 'has duplicate days') unless has_no_duplicates

      errors.add(:days_of_week, 'has no days specified') unless has_entries
    end
  end
end