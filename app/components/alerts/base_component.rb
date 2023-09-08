# frozen_string_literal: true

module Alerts
  class BaseComponent < ViewComponent::Base
    def initialize(message:)
      super
      @message = message
    end

    def context
      raise "Expected #{self.class} to implement context"
    end

    def color
      raise "Expected #{self.class} to implement color"
    end
  end
end
