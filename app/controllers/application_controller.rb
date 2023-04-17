# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # Here so Rubymine stops complaining
  def current_user # rubocop:disable Lint/UselessMethodDefinition
    super
  end

  def authenticate_user! # rubocop:disable Lint/UselessMethodDefinition
    super
  end
end
