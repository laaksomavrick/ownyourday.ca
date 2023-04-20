# frozen_string_literal: true

class GoalsController < ApplicationController
  def index
    @goals = policy_scope(Goal)
  end

  def show
    goal_id = params[:id].to_i
    @goal = authorize Goal.find_by(id: goal_id)
  end
end
