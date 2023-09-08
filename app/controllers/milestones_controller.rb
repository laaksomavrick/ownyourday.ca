# frozen_string_literal: true

class MilestonesController < ApplicationController
  def index
    goal_id = params[:goal_id]
    @goal = Goals::Goal.find_by(id: goal_id)
  end

  def new; end
end
