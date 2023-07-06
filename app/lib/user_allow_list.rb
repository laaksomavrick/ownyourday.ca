# frozen_string_literal: true

module UserAllowList
  class << self
    def email_in_allow_list?(email)
      allow_list = Rails.application.credentials[:user_allow_list]
      allow_list.include?(email)
    end
  end
end
