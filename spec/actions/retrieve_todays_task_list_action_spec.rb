# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RetrieveTodaysTaskListAction do
  describe 'task positions' do
    let!(:user) { create(:user) }

    it 'retrieves tasks ordered by position' do
      create(:daily_goal, user:, position: 0)
      create(:days_of_week_goal, user:, metadata: { 'days_of_week' => [0, 1, 2, 3, 4, 5, 6] }, position: 1)
      create(:times_per_week_goal, user:, metadata: { 'times_per_week' => 6 }, position: 2)

      task_list = GenerateTodaysTaskListAction.new(user:).call

      adhoc_task = create(:adhoc_task, task_list:, user:, position: 3)

      task_list = described_class.new(user:).call

      expect(task_list.goal_tasks.length).to be(3)
      expect(task_list.adhoc_tasks.length).to be(1)
      expect(task_list.tasks.length).to be(4)

      expect(task_list.tasks.first.position).to be(0)
      expect(task_list.tasks.second.position).to be(1)
      expect(task_list.tasks.third.position).to be(2)
      expect(task_list.tasks.fourth.position).to be(3)
      expect(task_list.tasks.fourth.id).to be(adhoc_task.id)
    end
  end

  SpecConstants::TIME_ZONES.each do |time_zone|
    SpecConstants::HOURS.each do |hour|
      context "when the user is in time zone #{time_zone} and the time is #{hour}:00" do
        let!(:user) { create(:user, time_zone:) }

        it "can retrieve today's task list" do
          user_today = DateTime.current.in_time_zone(time_zone).beginning_of_day
          user_yesterday = user_today.advance(days: -1)
          user_tomorrow = user_today.advance(days: 1)

          requested_retrieval_time = user_today.advance(hours: hour)

          create(:task_list, date: user_yesterday, user:)
          create(:task_list, date: user_tomorrow, user:)

          today_task_list = create(:task_list, date: user_today, user:)

          retrieved_task_list = described_class.new(user:).call(today: requested_retrieval_time)

          expect(retrieved_task_list.id).to eq today_task_list.id
        end
      end
    end
  end
end
