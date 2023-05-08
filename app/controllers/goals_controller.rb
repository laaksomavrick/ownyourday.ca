# frozen_string_literal: true

class GoalsController < ApplicationController
  def index
    @goals = policy_scope(Goals::Goal)
  end

  def new
    @goal = authorize Goals::Daily.new
    update_goal_action = UpdateGoalAction.new(@goal)
    @goal = update_goal_action.call(goal_params)
  end

  def edit
    goal_id = params[:id].to_i
    @goal = authorize Goals::Goal.find_by(id: goal_id)
    update_goal_action = UpdateGoalAction.new(@goal)
    @goal = update_goal_action.call(goal_params)
  end

  def create
    @goal = authorize Goals::Goal.new

    update_goal_action = UpdateGoalAction.new(@goal)
    @goal = update_goal_action.call(goal_params, { persist: true })

    if @goal.errors.empty? == false
      render 'new', status: :unprocessable_entity
      return
    end

    flash[:notice] = t('helpers.alert.create_successful', name: @goal.name)
    redirect_to edit_goal_path(@goal.id)
  end

  def update
    goal_id = params[:id].to_i
    @goal = authorize Goals::Goal.find_by(id: goal_id)

    update_goal_action = UpdateGoalAction.new(@goal)
    @goal = update_goal_action.call(goal_params, { persist: true })

    if @goal.errors.empty? == false
      render 'edit', status: :unprocessable_entity
      return
    end

    flash[:notice] = t('helpers.alert.update_successful', name: @goal.name)
    redirect_to edit_goal_path(@goal.id)
  end

  private

  def goal_params
    params.fetch(:goal, {}).permit(
      :user_id,
      :name,
      :type,
      :times_per_week,
      days_of_week: %w[0 1 2 3 4 5 6]
    )
  end
end
