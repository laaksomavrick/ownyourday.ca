# frozen_string_literal: true

module Goals
  class TimesPerWeek < Goals::Goal
    store_accessor :metadata, :times_per_week
    validate :metadata, :validate_metadata

    private

    def validate_metadata
      times_per_week = metadata['times_per_week'].to_i

      return false unless times_per_week.positive? && times_per_week <= 6

      return false unless times_per_week <= 6

      true
    end
  end
end
