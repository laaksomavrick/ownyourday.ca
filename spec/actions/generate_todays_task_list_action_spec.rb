# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GenerateTodaysTaskListAction do
  let!(:user) { create(:user) }

  it 'creates a task list' do
    task_list = described_class.new(user:).call
    expect(task_list).to be_present
  end

  context 'when user has a daily goal' do
    let!(:daily_goal) { create(:daily_goal, user:) }

    it 'creates a task from the daily goal' do
      task_list = described_class.new(user:).call
      daily_goal_task = task_list.tasks.where(goal_id: daily_goal.id).first
      expect(daily_goal_task).to be_present
    end
  end

  context 'when user has a days of week goal' do
    let!(:days_of_week_goal) do
      create(:days_of_week_goal, user:, metadata: { 'days_of_week' => [0] })
    end

    it 'creates a task when today is the same day of week as the goal' do
      monday = DateTime.current.utc.beginning_of_week
      task_list = described_class.new(user:).call(today: monday)
      day_of_week_goal_task = task_list.tasks.where(goal_id: days_of_week_goal.id).first
      expect(day_of_week_goal_task).to be_present
    end

    it 'does not create a task when today is not the same day of week as the goal' do
      tuesday = DateTime.current.utc.beginning_of_week.advance(days: 1)
      task_list = described_class.new(user:).call(today: tuesday)
      day_of_week_goal_task = task_list.tasks.where(goal_id: days_of_week_goal.id).first
      expect(day_of_week_goal_task).not_to be_present
    end
  end
end
