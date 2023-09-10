# frozen_string_literal: true

class MilestonesController < ApplicationController
  def index
    goal_id = params[:goal_id]
    @goal = Goals::Goal.find_by(id: goal_id)
    @active_milestone = @goal.active_milestone
    @inactive_milestones = @goal.inactive_milestones
  end

  def new; end

  def edit; end
end
