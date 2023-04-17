# frozen_string_literal: true

class GoalsController < ApplicationController
  def index
    @goals = current_user.goals
  end
end
