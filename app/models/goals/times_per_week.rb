# frozen_string_literal: true

module Goals
  class TimesPerWeek < Goals::Goal
    store_accessor :metadata, :times_per_week
    validate :metadata, :validate_metadata

    DEFAULT_SCHEDULE = 1

    def times_per_week
      data = metadata['times_per_week']

      return DEFAULT_SCHEDULE if data.nil?

      data.to_i
    end

    def times_per_week=(value)
      times_per_week = value.to_i
      self.metadata = { times_per_week: }
    end

    private

    def validate_metadata
      errors.add(:times_per_week, 'must be greater than 0') unless times_per_week.positive?
      errors.add(:times_per_week, 'must be less than 7') unless times_per_week <= 6
    end
  end
end
