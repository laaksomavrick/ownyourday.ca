# frozen_string_literal: true

module Alerts
  class DangerComponent < BaseComponent
    def color
      'red'
    end

    def context
      'Error'
    end
  end
end
