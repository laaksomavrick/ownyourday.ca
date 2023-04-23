# frozen_string_literal: true

module Goals
  class Daily < Goals::Goal
    validate :metadata, :validate_metadata

    private

    def validate_metadata
      is_valid = metadata == '{}'
      errors.add(:metadata, 'is invalid') unless is_valid
    end
  end
end
