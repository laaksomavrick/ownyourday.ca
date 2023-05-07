# frozen_string_literal: true

class GoalsController < ApplicationController
  def index
    @goals = policy_scope(Goals::Goal)
  end

  def new
    @goal = authorize Goals::Daily.new
    @goal = update_goal_from_form(@goal)
  end

  def edit
    goal_id = params[:id].to_i
    @goal = authorize Goals::Goal.find_by(id: goal_id)
    @goal = update_goal_from_form(@goal, goal_id)
  end

  def create
    @goal = authorize Goals::Goal.new
    @goal = update_goal_from_form(@goal)
    @goal.user = current_user
    @goal.save

    # TODO: validate if type = days_of_week that cannot be empty
    # TODO: validate if type = times_per_week that cannot be < 0 or > 6

    if @goal.errors.empty? == false
      render 'new', status: :unprocessable_entity
      return
    end

    flash[:notice] = t('helpers.alert.create_successful', name: @goal.name)
    redirect_to edit_goal_path(@goal.id)
  end

  private

  def update_goal_from_form(goal, goal_id = nil)
    if goal_params[:type]
      goal = Goals::Goal.new(goal_params.slice(:id, :name, :type))
      goal.id = goal_id if goal_id
    end

    if goal_params[:times_per_week] && goal.is_times_per_week?
      times_per_week = goal_params[:times_per_week]
      goal.times_per_week = times_per_week
    end

    if goal_params[:days_of_week] && goal.is_days_of_week?
      days_of_week_keys = goal_params[:days_of_week].keys.map(&:to_s)
      days_of_week = days_of_week_keys.filter { |day| goal_params[:days_of_week][day] == '1' }
      goal.days_of_week = days_of_week
    end

    goal
  end

  def goal_params
    params.fetch(:goal, {}).permit(
      :name,
      :type,
      :times_per_week,
      days_of_week: %w[0 1 2 3 4 5 6]
    )
  end
end
