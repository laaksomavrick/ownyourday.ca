# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RetrieveTodaysTaskListAction do
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
