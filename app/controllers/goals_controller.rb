# frozen_string_literal: true

class GoalsController < ApplicationController
  def index
    @goals = policy_scope(Goals::Goal)
  end

  def edit
    goal_id = params[:id].to_i
    @goal = authorize Goals::Goal.find_by(id: goal_id)

    if goal_params[:type]
      @goal = Goals::Goal.new(goal_params.slice(:id, :name, :type))
      @goal.id = goal_id
    end

    @goal.times_per_week = goal_params[:times_per_week] if goal_params[:times_per_week]

    # Why isn't this working?!
    if goal_params[:days_of_week]
      days_of_week_keys = goal_params[:days_of_week].keys.map(&:to_s)
      days_of_week = days_of_week_keys.filter { |day| goal_params[:days_of_week][day] == '1' }
      @goal.days_of_week = days_of_week
    end

    @goal
  end

  private

  def goal_params
    params.fetch(:goal, {}).permit(
      :name,
      :type,
      :times_per_week,
      days_of_week: %w[0 1 2 3 4 5 6]
    )
  end
end
