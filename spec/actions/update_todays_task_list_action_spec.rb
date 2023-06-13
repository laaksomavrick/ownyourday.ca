# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateTodaysTaskListAction do
  let!(:user) { create(:user) }
  let!(:daily_goal) { create(:daily_goal, user:, position: 0) }
  let!(:daily_goal_two) { create(:daily_goal, user:, position: 1) }
  let!(:task_list) { GenerateTodaysTaskListAction.new(user:).call }
  let!(:adhoc_task) { create(:adhoc_task, user:, task_list:, position: 2) }

  before do
    task_list.tasks.where(goal_id: daily_goal_two.id).update(completed: true)
  end

  context 'when a new goal is created' do
    it 'adds a new task' do
      new_goal = create(:daily_goal, user:, position: 3)

      described_class.new(goal: new_goal).call

      expect(user.task_lists.count).to eq 1

      new_task_list = user.task_lists.first
      expect(new_task_list.id).not_to eq task_list.id
      expect(new_task_list.tasks.count).to eq 4
      expect(new_task_list.tasks.find_by(goal_id: new_goal.id).position).to eq 3
      expect(new_task_list.tasks.find_by(goal_id: daily_goal_two.id).completed).to be true
    end
  end

  context 'when an existing goal is deleted' do
    it 'removes the task' do
      daily_goal.destroy

      described_class.new(goal: daily_goal_two).call

      expect(user.task_lists.count).to eq 1

      new_task_list = user.task_lists.first
      expect(new_task_list.id).not_to eq task_list.id
      expect(new_task_list.tasks.count).to eq 3
      expect(new_task_list.tasks.find_by(goal_id: daily_goal.id)).to be_nil
      expect(new_task_list.tasks.find_by(goal_id: daily_goal_two.id).completed).to be true
    end
  end

  context 'when an existing goal is modified' do
    pending 'updates the task when the goal name is changed'
    pending 'updates the task when the goal type is changed'
    pending 'updates the task when the goal metadata is changed'
  end
end
