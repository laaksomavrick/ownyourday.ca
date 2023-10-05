# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!

  helper_method :breadcrumbs

  # Here so Rubymine stops complaining
  def current_user # rubocop:disable Lint/UselessMethodDefinition
    super
  end

  def authenticate_user! # rubocop:disable Lint/UselessMethodDefinition
    super
  end

  def breadcrumbs
    @breadcrumbs ||= []
  end

  def add_breadcrumb(name, path = nil)
    breadcrumbs << Breadcrumb.new(name, path)
  end

  private

  # See config/environments/support/logger.rb
  def append_info_to_payload(payload)
    super
    payload[:level] =
      case payload[:status]
      when (200..399)
        'INFO'
      when (400..499)
        'WARN'
      else
        'ERROR'
      end
    payload[:host] = request.host
    payload[:remote_ip] = request.remote_ip
    payload[:ip] = request.ip
    payload[:user_id] = current_user.id if current_user
  end
end
