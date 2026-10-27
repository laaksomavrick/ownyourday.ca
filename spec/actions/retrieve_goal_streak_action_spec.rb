# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RetrieveGoalStreakAction do
  let(:time_zone) { 'America/Toronto' }
  let!(:user) { create(:user, time_zone:, created_at: 5.weeks.ago) }

  def task_list_for(today)
    task_list = RetrieveTodaysTaskListAction.new(user:).call(today:)
    task_list || GenerateTodaysTaskListAction.new(user:).call(today:)
  end

  def complete(goal, today)
    task_list_for(today).tasks.find_by(goal_id: goal.id).update!(completed: true)
  end

  def streak(goal)
    described_class.new(user:, goal:).call
  end

  context 'when the goal is a daily goal' do
    let!(:goal) { create(:daily_goal, user:) }

    it 'counts consecutive completed days up to today' do
      complete(goal, 2.days.ago)
      complete(goal, 1.day.ago)
      complete(goal, DateTime.current)

      expect(streak(goal)).to eq 3
    end

    it 'is not reset by viewing a future day' do
      complete(goal, 2.days.ago)
      complete(goal, 1.day.ago)
      complete(goal, DateTime.current)
      task_list_for(1.day.from_now)

      expect(streak(goal)).to eq 3
    end

    it 'is not inflated when goals change' do
      task_list_for(2.days.ago)
      complete(goal, 1.day.ago)
      complete(goal, DateTime.current)
      task_list_for(3.days.ago)

      create(:daily_goal, user:, position: 1)

      expect(streak(goal)).to eq 2
      expect(goal.tasks.where(completed: true).count).to eq 2
    end
  end

  context 'when the goal is a times per week goal' do
    let!(:goal) { create(:times_per_week_goal, user:, metadata: { 'times_per_week' => 1 }) }
    let(:monday) { DateTime.current.in_time_zone(time_zone).beginning_of_week + 12.hours }

    it 'counts completions in consecutive weeks that met the goal' do
      complete(goal, monday - 14.days)
      complete(goal, monday - 7.days)
      complete(goal, monday)

      expect(streak(goal)).to eq 3
    end

    it 'is broken by a week with no completions' do
      complete(goal, monday - 14.days)
      task_list_for(monday - 7.days)
      complete(goal, monday)

      expect(streak(goal)).to eq 1
    end

    context 'when the user is east of UTC' do
      let(:time_zone) { 'Asia/Tokyo' }

      it "groups completions by the user's week" do
        complete(goal, monday - 7.days)
        complete(goal, monday)

        expect(streak(goal)).to eq 2
      end
    end
  end
end
