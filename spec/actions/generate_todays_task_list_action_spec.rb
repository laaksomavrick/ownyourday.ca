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

  context 'when user has a times per week goal' do
    let!(:times_per_week_goal) do
      create(:times_per_week_goal, user:, metadata: { 'times_per_week' => 2 })
    end

    it 'creates a task when times per week completions are not exceeded' do
      task_list = described_class.new(user:).call
      times_per_week_goal_task = task_list.tasks.where(goal_id: times_per_week_goal.id).first
      expect(times_per_week_goal_task).to be_present
    end

    it 'does not create a task when times per week completions are met' do
      today = DateTime.current.utc.beginning_of_week.advance(days: 3)
      two_days_ago = today.advance(days: -2)
      yesterday = today.advance(days: -1)

      task_list_two_days_ago = described_class.new(user:).call(today: two_days_ago)
      task_list_yesterday = described_class.new(user:).call(today: yesterday)

      task_two_days_ago = task_list_two_days_ago.tasks.where(goal_id: times_per_week_goal.id).first
      task_yesterday = task_list_yesterday.tasks.where(goal_id: times_per_week_goal.id).first

      task_two_days_ago.completed = true
      task_two_days_ago.save!

      task_yesterday.completed = true
      task_yesterday.save!

      task_list_today = described_class.new(user:).call(today:)

      task_today = task_list_today.tasks.where(goal_id: times_per_week_goal.id)

      expect(task_today).to be_empty
    end
  end
end
