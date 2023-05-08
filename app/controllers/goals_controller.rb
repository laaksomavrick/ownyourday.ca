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
    @goal = update_goal_from_form(@goal)
  end

  def create
    @goal = authorize Goals::Goal.new
    @goal = update_goal_from_form(@goal)
    @goal.user = current_user
    @goal.save

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
    @goal = update_goal_from_form(@goal)
    @goal.save

    if @goal.errors.empty? == false
      render 'edit', status: :unprocessable_entity
      return
    end

    flash[:notice] = t('helpers.alert.update_successful', name: @goal.name)
    redirect_to edit_goal_path(@goal.id)
  end

  private

  # TODO: extract this into an action e.g. UpsertGoal(params, { persistence: true })
  def update_goal_from_form(goal)
    if goal_params[:type]
      type = goal_params[:type].constantize
      goal = goal.becomes(type)
      goal.type = type
      case goal.type
      when Goals::Daily.name
        goal.metadata = '{}'
      when Goals::TimesPerWeek.name
        goal.times_per_week = 1
      when Goals::DaysOfWeek.name
        goal.days_of_week = [0]
      else
        raise "Unknown type when updating goal type=#{goal.type}"
      end
    end

    goal.name = goal_params[:name] if goal_params[:name]

    # goal.user = user if user

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
