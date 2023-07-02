# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RetrieveGoalsStreakAction do
  let!(:user) { create(:user, created_at: 14.days.ago) }

  context 'when the goal is a times per week goal' do
    let!(:goal) { create(:times_per_week_goal, user:, metadata: { 'times_per_week' => 2 }) }

    it 'retrieves streak when all prior weeks tasks have been completed' do
      monday = user.beginning_of_day.monday
      monday_one_week_ago = monday - 7.days
      monday_two_weeks_ago = monday - 14.days
      goal_id = goal.id

      two_weeks_ago_task_list = GenerateTodaysTaskListAction.new(user:).call(today: monday_two_weeks_ago)
      another_two_weeks_ago_task_list = GenerateTodaysTaskListAction.new(user:).call(today: monday_two_weeks_ago + 1.day)
      one_week_ago_task_list = GenerateTodaysTaskListAction.new(user:).call(today: monday_one_week_ago)
      another_one_week_ago_task_list = GenerateTodaysTaskListAction.new(user:).call(today: monday_one_week_ago + 1.day)
      today_task_list = GenerateTodaysTaskListAction.new(user:).call

      two_weeks_ago_task_list.tasks.first.update(completed: true)
      another_two_weeks_ago_task_list.tasks.first.update(completed: true)
      one_week_ago_task_list.tasks.first.update(completed: true)
      another_one_week_ago_task_list.tasks.first.update(completed: true)

      today_task_list.tasks.first.update(completed: false)

      streaks = described_class.new(user:, goals: [goal]).call
      goal_streak = streaks[goal_id]

      expect(goal_streak).to eq 4
    end

    it 'retrieves streak when all prior weeks tasks and some tasks this week have been completed' do
      monday = user.beginning_of_day.monday
      monday_one_week_ago = monday - 7.days
      monday_two_weeks_ago = monday - 14.days
      goal_id = goal.id

      two_weeks_ago_task_list = GenerateTodaysTaskListAction.new(user:).call(today: monday_two_weeks_ago)
      another_two_weeks_ago_task_list = GenerateTodaysTaskListAction.new(user:).call(today: monday_two_weeks_ago + 1.day)
      one_week_ago_task_list = GenerateTodaysTaskListAction.new(user:).call(today: monday_one_week_ago)
      another_one_week_ago_task_list = GenerateTodaysTaskListAction.new(user:).call(today: monday_one_week_ago + 1.day)
      today_task_list = GenerateTodaysTaskListAction.new(user:).call

      two_weeks_ago_task_list.tasks.first.update(completed: true)
      another_two_weeks_ago_task_list.tasks.first.update(completed: true)
      one_week_ago_task_list.tasks.first.update(completed: true)
      another_one_week_ago_task_list.tasks.first.update(completed: true)
      today_task_list.tasks.first.update(completed: true)

      streaks = described_class.new(user:, goals: [goal]).call
      goal_streak = streaks[goal_id]

      expect(goal_streak).to eq 5
    end

    it 'retrieves streak when no prior tasks have been completed' do
      monday = user.beginning_of_day.monday
      monday_one_week_ago = monday - 7.days
      monday_two_weeks_ago = monday - 14.days
      goal_id = goal.id

      GenerateTodaysTaskListAction.new(user:).call(today: monday_two_weeks_ago)
      GenerateTodaysTaskListAction.new(user:).call(today: monday_two_weeks_ago + 1.day)
      GenerateTodaysTaskListAction.new(user:).call(today: monday_one_week_ago)
      GenerateTodaysTaskListAction.new(user:).call(today: monday_one_week_ago + 1.day)
      GenerateTodaysTaskListAction.new(user:).call

      streaks = described_class.new(user:, goals: [goal]).call
      goal_streak = streaks[goal_id]

      expect(goal_streak).to eq 0
    end

    it 'retrieves streak when some prior tasks were not completed' do
      monday = user.beginning_of_day.monday
      monday_one_week_ago = monday - 7.days
      monday_two_weeks_ago = monday - 14.days
      goal_id = goal.id

      two_weeks_ago_task_list = GenerateTodaysTaskListAction.new(user:).call(today: monday_two_weeks_ago)
      another_two_weeks_ago_task_list = GenerateTodaysTaskListAction.new(user:).call(today: monday_two_weeks_ago + 1.day)
      one_week_ago_task_list = GenerateTodaysTaskListAction.new(user:).call(today: monday_one_week_ago)
      another_one_week_ago_task_list = GenerateTodaysTaskListAction.new(user:).call(today: monday_one_week_ago + 1.day)
      today_task_list = GenerateTodaysTaskListAction.new(user:).call

      two_weeks_ago_task_list.tasks.first.update(completed: true)
      another_two_weeks_ago_task_list.tasks.first.update(completed: false)
      one_week_ago_task_list.tasks.first.update(completed: true)
      another_one_week_ago_task_list.tasks.first.update(completed: true)
      today_task_list.tasks.first.update(completed: false)

      streaks = described_class.new(user:, goals: [goal]).call
      goal_streak = streaks[goal_id]

      expect(goal_streak).to eq 2
    end

    it 'retrieves streak when some prior tasks were not completed and today is completed' do
      monday = user.beginning_of_day.monday
      monday_one_week_ago = monday - 7.days
      monday_two_weeks_ago = monday - 14.days
      goal_id = goal.id

      two_weeks_ago_task_list = GenerateTodaysTaskListAction.new(user:).call(today: monday_two_weeks_ago)
      another_two_weeks_ago_task_list = GenerateTodaysTaskListAction.new(user:).call(today: monday_two_weeks_ago + 1.day)
      one_week_ago_task_list = GenerateTodaysTaskListAction.new(user:).call(today: monday_one_week_ago)
      another_one_week_ago_task_list = GenerateTodaysTaskListAction.new(user:).call(today: monday_one_week_ago + 1.day)
      today_task_list = GenerateTodaysTaskListAction.new(user:).call

      two_weeks_ago_task_list.tasks.first.update(completed: true)
      another_two_weeks_ago_task_list.tasks.first.update(completed: false)
      one_week_ago_task_list.tasks.first.update(completed: true)
      another_one_week_ago_task_list.tasks.first.update(completed: true)
      today_task_list.tasks.first.update(completed: true)

      streaks = described_class.new(user:, goals: [goal]).call
      goal_streak = streaks[goal_id]

      expect(goal_streak).to eq 3
    end
  end

  context 'when the goal is a daily goal' do
    let!(:goal) { create(:daily_goal, user:) }

    it 'retrieves streak when all prior tasks have been completed' do
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

    it 'retrieves streak when no tasks have been completed' do
      goal_id = goal.id

      GenerateTodaysTaskListAction.new(user:).call(today: 2.days.ago)
      GenerateTodaysTaskListAction.new(user:).call(today: 1.day.ago)
      GenerateTodaysTaskListAction.new(user:).call

      streaks = described_class.new(user:, goals: [goal]).call
      goal_streak = streaks[goal_id]

      expect(goal_streak).to eq 0
    end

    it 'retrieves streak when a prior task was not completed' do
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
