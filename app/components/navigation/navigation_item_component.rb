# frozen_string_literal: true

module Navigation
  class NavigationItemComponent < ViewComponent::Base
    include ApplicationHelper

    def initialize(path:, title:)
      @path = path
      @title = title
    end

    def text_color
      is_active? ? "#{brand_color}-500" : "#{brand_color}-300"
    end

    private

    def is_active?
      current_page?(@path) || request.path.starts_with?(@path)
    end
  end
end
