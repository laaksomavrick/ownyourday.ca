# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateTodaysTaskListAction do
  let!(:user) { create(:user) }
  let!(:daily_goal) { create(:daily_goal, user:, position: 0) }
  let!(:daily_goal_two) { create(:daily_goal, user:, position: 1) }
  let!(:task_list) { GenerateTodaysTaskListAction.new(user:).call }
  # rubocop:disable RSpec/LetSetup
  let!(:adhoc_task) { create(:adhoc_task, user:, task_list:, position: 2) }
  # rubocop:enable RSpec/LetSetup

  before do
    task_list.tasks.where(goal_id: daily_goal_two.id).update(completed: true)
  end

  context 'when a new goal is created' do
    let!(:new_goal) { create(:daily_goal, user:, position: 3) }

    it 'adds a new task' do
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
    before do
      daily_goal.destroy
    end

    it 'removes the task' do
      described_class.new(goal: daily_goal_two).call

      expect(user.task_lists.count).to eq 1

      new_task_list = user.task_lists.first
      expect(new_task_list.id).not_to eq task_list.id
      expect(new_task_list.tasks.count).to eq 2
      expect(new_task_list.tasks.find_by(goal_id: daily_goal.id)).to be_nil
      expect(new_task_list.tasks.find_by(goal_id: daily_goal_two.id).completed).to be true
    end
  end

  context 'when an existing goal is modified' do
    name = Faker::Lorem.word
    position = 1
    type = 'Goals::TimesPerWeek'
    times_per_week = 3

    before do
      UpdateGoalAction.new(daily_goal).call({ name:, position:, type:, times_per_week: }, { persist: true })
    end

    it 'updates the task when the goal is changed' do
      described_class.new(goal: daily_goal).call

      expect(user.task_lists.count).to eq 1

      new_task_list = user.task_lists.first
      updated_task = new_task_list.tasks.find_by(goal_id: daily_goal.id)

      expect(new_task_list.id).not_to eq task_list.id
      expect(new_task_list.tasks.count).to eq 3

      expect(updated_task.name).to eq name
      expect(updated_task.position).to eq position
      expect(updated_task.goal.type).to eq type
      expect(updated_task.goal.times_per_week).to eq times_per_week
    end
  end
end
