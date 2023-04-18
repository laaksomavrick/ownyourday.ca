# frozen_string_literal: true

class GoalsController < ApplicationController
  def index
    @goals = policy_scope(Goal)
  end
end
