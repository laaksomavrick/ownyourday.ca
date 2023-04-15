# frozen_string_literal: true

module Navigation
  class NavigationItemComponent < ViewComponent::Base
    include ApplicationHelper

    def initialize(path:, title:)
      super
      @path = path
      @title = title
    end

    def text_color
      active? ? "#{brand_color}-500" : "#{brand_color}-300"
    end

    private

    def active?
      current_page?(@path) || request.path.starts_with?(@path)
    end
  end
end
