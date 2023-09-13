# frozen_string_literal: true

# TODO: authorization

class MilestonesController < ApplicationController
  def index
    goal_id = params[:goal_id]
    @goal = Goals::Goal.find_by(id: goal_id)
    @active_milestone = @goal.active_milestone
    @inactive_milestones = @goal.inactive_milestones
  end

  def new
    goal_id = params[:goal_id]
    @goal = Goals::Goal.find_by(id: goal_id)
    @milestone = Milestone.new(goal: @goal, completed: false)
  end

  def edit; end

  # TODO: extract service class
  def create
    goal_id = params[:goal_id]
    params = create_milestone_params

    @goal = Goals::Goal.find_by(id: goal_id)

    active_milestone = @goal.active_milestone

    @milestone = Milestone.new
    @milestone.goal = @goal
    @milestone.name = params[:name]
    @milestone.description = params[:description]
    @milestone.completed = false

    if active_milestone
      flash.now[:alert] = t('milestones.new.active_milestone_error')
      render 'new', status: :unprocessable_entity
      return
    end

    @milestone.save

    if @milestone.errors.empty? == false
      render 'new', status: :unprocessable_entity
      return
    end

    flash[:notice] = t('helpers.alert.create_successful', name: @milestone.name)
    redirect_to edit_goal_path(@goal)
  end

  private

  def create_milestone_params
    params.fetch(:milestone, {}).permit(
      :name,
      :description
    )
  end
end
