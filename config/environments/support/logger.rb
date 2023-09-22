# frozen_string_literal: true

Rails.application.configure do
  config.logger = ActiveSupport::Logger.new($stdout)

  config.log_level = :info
  config.log_tags = [:request_id]

  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::Json.new
  config.lograge.custom_options = lambda do |event|
    {
      exception: event.payload[:exception]&.first,
      exception_message: event.payload[:exception_object]&.message,
      exception_trace: event.payload[:exception_object]&.backtrace&.first(3),
      host: event.payload[:host],
      ip: event.payload[:ip],
      level: event.payload[:level],
      params: event.payload[:params].except(:action, :controller).to_json,
      process_id: Process.pid,
      rails_env: Rails.env,
      remote_ip: event.payload[:remote_ip],
      request_id: event.payload[:headers]['action_dispatch.request_id'],
      request_time: Time.zone.now,
      x_forwarded_for: event.payload[:x_forwarded_for],
      user_id: event.payload[:user_id],
      application_version: ApplicationVersion.version
    }.compact
  end

  config.lograge.ignore_custom = lambda do |event|
    event.payload[:user_id].nil?
  end
end
