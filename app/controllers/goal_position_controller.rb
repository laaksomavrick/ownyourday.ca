# frozen_string_literal: true

class GoalPositionController < ApplicationController
  def update
    id = params[:id]
    position = goal_position_update_params[:position].to_i

    @goal = authorize Goals::Goal.find_by(id:)
    @goal.insert_at(position)
    @goals = current_user.goals.order(:position)

    flash.now[:alert] = t('helpers.alert.update_failed', name: @goal.name) if @goal.errors.empty? == false
  end

  private

  def goal_position_update_params
    params.require(:id)
    params.require(:goal_position).tap do |goal_position_params|
      goal_position_params.require(:position)
    end
  end
end
