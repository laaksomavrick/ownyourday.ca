# frozen_string_literal: true

module Goals
  class Daily < Goals::Goal
    validate :metadata, :validate_metadata

    private

    def validate_metadata
      metadata == '{}'
    end
  end
end
