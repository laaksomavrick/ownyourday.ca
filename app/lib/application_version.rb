# frozen_string_literal: true

module ApplicationVersion
  class << self
    def version
      ENV.fetch('APPLICATION_VERSION', 'Unknown')
    end
  end
end
