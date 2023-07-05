# frozen_string_literal: true

module FeatureFlags
  class << self
    def users_registration_allow_list_enabled?
      ENV.fetch('FEATURE_FLAGS_USERS_REGISTRATION_ALLOW_LIST') { Rails.configuration.feature_flags[:users_registration_allow_list] }
    end
  end
end
