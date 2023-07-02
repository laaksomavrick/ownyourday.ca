# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RetrieveGoalsStreakAction do
  let!(:user) { create(:user) }

  context 'when g'

  context 'when goal is a daily goal' do
    let!(:goal) { create(:daily_goal, user:) }

    it 'retrieves streaks when all prior tasks have been completed' do
      goal_id = goal.id

      two_day_ago_task_list = GenerateTodaysTaskListAction.new(user:).call(today: 2.days.ago)
      one_day_ago_task_list = GenerateTodaysTaskListAction.new(user:).call(today: 1.day.ago)
      today_task_list = GenerateTodaysTaskListAction.new(user:).call

      two_day_ago_task_list.tasks.first.update(completed: true)
      one_day_ago_task_list.tasks.first.update(completed: true)
      today_task_list.tasks.first.update(completed: false)

      streaks = described_class.new(user:, goals: [goal]).call
      goal_streak = streaks[goal_id]

      expect(goal_streak).to eq 2
    end

    it 'retrieves streaks when no tasks have been completed' do
      goal_id = goal.id

      GenerateTodaysTaskListAction.new(user:).call(today: 2.days.ago)
      GenerateTodaysTaskListAction.new(user:).call(today: 1.day.ago)
      GenerateTodaysTaskListAction.new(user:).call

      streaks = described_class.new(user:, goals: [goal]).call
      goal_streak = streaks[goal_id]

      expect(goal_streak).to eq 0
    end

    it 'retrieves streaks when a prior task was not completed' do
      goal_id = goal.id

      two_day_ago_task_list = GenerateTodaysTaskListAction.new(user:).call(today: 2.days.ago)
      one_day_ago_task_list = GenerateTodaysTaskListAction.new(user:).call(today: 1.day.ago)
      today_task_list = GenerateTodaysTaskListAction.new(user:).call

      two_day_ago_task_list.tasks.first.update(completed: false)
      one_day_ago_task_list.tasks.first.update(completed: true)
      today_task_list.tasks.first.update(completed: false)

      streaks = described_class.new(user:, goals: [goal]).call
      goal_streak = streaks[goal_id]

      expect(goal_streak).to eq 1
    end
  end
end
