# frozen_string_literal: true

module Breadcrumbs
  class BreadcrumbsComponent < ViewComponent::Base
    attr_reader :breadcrumbs

    def initialize(breadcrumbs:)
      super
      @breadcrumbs = breadcrumbs || []
    end
  end
end
