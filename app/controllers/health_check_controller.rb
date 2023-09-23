# frozen_string_literal: true

# rubocop:disable Rails/ApplicationController
class HealthCheckController < ActionController::Base
  def index
    render json: { health_status: :ok }
  end
end

# rubocop:enable Rails/ApplicationController
