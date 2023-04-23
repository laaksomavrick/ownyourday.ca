# frozen_string_literal: true

class GoalsController < ApplicationController
  def index
    @goals = policy_scope(Goals::Goal)
  end

  def show
    goal_id = params[:id].to_i
    @goal = authorize Goals::Goal.find_by(id: goal_id)
  end
end
