# frozen_string_literal: true

module Navigation
  class NavigationUserItemComponent < ViewComponent::Base
    include ApplicationHelper

    def initialize(path:, user:)
      super
      @path = path
      @user = user
    end

    def bg_color
      return 'gray-100' if avatar?

      active? ? "#{brand_color}-500" : "#{brand_color}-300"
    end

    private

    def avatar?
      @user.avatar.attached?
    end

    def active?
      current_page?(@path) || request.path.starts_with?(@path)
    end
  end
end
