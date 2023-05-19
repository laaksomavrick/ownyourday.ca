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
end
