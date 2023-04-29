# frozen_string_literal: true

class GoalsController < ApplicationController
  def index
    @goals = policy_scope(Goals::Goal)
  end

  def edit
    goal_id = params[:id].to_i
    @goal = authorize Goals::Goal.find_by(id: goal_id)

    if goal_params[:type]
      @goal = Goals::Goal.new(goal_params)
      @goal.id = goal_id
    end

    @goal
  end

  private

  def goal_params
    params.fetch(:goal, {}).permit(
      :name,
      :type
    )
  end
end
