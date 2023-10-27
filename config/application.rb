# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ownyourday
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Get rid of "field_with_errors" wrapper on form validation errors
    # https://gist.github.com/ehsanatwork/6dd0c65e290ee505a103a62ad24b3675?permalink_comment_id=4453466#gistcomment-4453466
    # rubocop:disable Rails/OutputSafety
    config.action_view.field_error_proc = proc do |html_tag, _instance|
      html_tag.html_safe
    end
    # rubocop:enable Rails/OutputSafety

    # Add feature flags to config
    config.feature_flags = config_for(:feature_flags)

    # ImageMagick
    config.active_storage.variant_processor = :mini_magick
  end
end
