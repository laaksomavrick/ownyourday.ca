# frozen_string_literal: true

class MilestonePolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      scope.includes(:goal).where(goal: { user_id: user.id })
    end

    private

    attr_reader :user, :scope
  end

  def update?
    user.id == record.goal.user_id
  end

  def create?
    true
  end

  def destroy?
    user.id == record.goal.user_id
  end

  def show?
    user.id == record.goal.user_id
  end
end
