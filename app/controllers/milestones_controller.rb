# frozen_string_literal: true

# TODO: authorization

class MilestonesController < ApplicationController
  def index
    goal_id = params[:goal_id]
    @goal = authorize Goals::Goal.find_by(id: goal_id)
    @active_milestone = @goal.active_milestone
    @inactive_milestones = @goal.inactive_milestones
    add_breadcrumb(@goal.name, edit_goal_path(@goal))
    add_breadcrumb(I18n.t('milestones.navigation'), goal_milestones_path(@goal))
  end

  def new
    goal_id = params[:goal_id]
    @goal = authorize Goals::Goal.find_by(id: goal_id)
    @milestone = Milestone.new(goal: @goal, completed: false)

    add_breadcrumb(@goal.name, edit_goal_path(@goal))
    add_breadcrumb(I18n.t('milestones.navigation'), goal_milestones_path(@goal))
    add_breadcrumb(I18n.t('common.new'), new_goal_milestone_path(@goal))
  end

  def edit
    goal_id = params[:goal_id]
    milestone_id = params[:id]

    @goal = authorize Goals::Goal.find_by(id: goal_id)
    @milestone = @goal.active_milestone

    if @milestone.nil?
      redirect_to goal_milestones_path(@goal)
      return
    end

    add_breadcrumb(@goal.name, edit_goal_path(@goal))
    add_breadcrumb(I18n.t('milestones.navigation'), goal_milestones_path(@goal))
    add_breadcrumb(@milestone.name, edit_goal_milestone_path(@goal, @milestone))

    return unless @milestone.try(:id) != milestone_id.to_i

    redirect_to edit_goal_milestone_path(@goal, @milestone)
    nil
  end

  def create
    goal_id = params[:goal_id]
    params = create_milestone_params

    @goal = authorize Goals::Goal.find_by(id: goal_id)

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
    redirect_to goal_milestones_path(@goal)
  end

  def update
    goal_id = params[:goal_id]
    milestone_id = params[:id]
    params = update_milestone_params

    @goal = authorize Goals::Goal.find_by(id: goal_id)
    @milestone = Milestone.find_by(id: milestone_id)

    @milestone.name = params[:name]
    @milestone.description = params[:description]
    @milestone.completed = params[:completed]
    @milestone.completed_at = DateTime.current.utc.in_time_zone(current_user.time_zone)

    @milestone.save

    if @milestone.errors.empty? == false
      render 'new', status: :unprocessable_entity
      return
    end

    flash[:notice] = t('helpers.alert.update_successful', name: @milestone.name)
    redirect_to goal_milestones_path(@goal)
  end

  def destroy
    milestone_id = params[:id].to_i

    @milestone = Milestone.find_by(id: milestone_id)
    goal = authorize @milestone.goal
    @milestone.destroy

    flash[:notice] = t('.success', name: @milestone.name)
    redirect_to edit_goal_path(goal)
  end

  private

  def create_milestone_params
    params.fetch(:milestone, {}).permit(
      :name,
      :description
    )
  end

  def update_milestone_params
    params.fetch(:milestone, {}).permit(
      :name,
      :description,
      :completed
    )
  end
end
