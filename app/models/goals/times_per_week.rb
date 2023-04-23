# frozen_string_literal: true

module Goals
  class TimesPerWeek < Goals::Goal
    store_accessor :metadata, :times_per_week
    validate :metadata, :validate_metadata

    private

    def validate_metadata
      times_per_week = metadata['times_per_week'].to_i

      errors.add(:times_per_week, 'must be greater than 0') unless times_per_week.positive?
      errors.add(:times_per_week, 'must be less than 7') unless times_per_week <= 6
    end
  end
end
