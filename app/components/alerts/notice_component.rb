# frozen_string_literal: true

module Alerts
  class NoticeComponent < BaseComponent
    def color
      'blue'
    end

    def context
      'Info'
    end
  end
end
