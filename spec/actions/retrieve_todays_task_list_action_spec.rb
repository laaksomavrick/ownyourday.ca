# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RetrieveTodaysTaskListAction do
  context 'when the user lives in UTC' do
    let!(:user) { create(:user) }

    it "retrieves today's task list" do
      date = DateTime.current.utc.beginning_of_day
      task_list = create(:task_list, date:, user:)

      retrieved_task_list = described_class.new(user:).call

      expect(retrieved_task_list.date).to eq task_list.date
    end
  end

  context 'when the user lives in a negative offset from UTC' do
    let!(:user) { create(:user, time_zone: 'EST') }

    context 'when the tz offset results in the same day' do
      it "retrieves today's task list" do
        date = DateTime.current.utc.beginning_of_day

        # 6am UTC - EST is either -4 or -5
        time_user_requested_task_list = date.advance(hours: 6)

        task_list = create(:task_list, date:, user:)

        retrieved_task_list = described_class.new(user:).call(today: time_user_requested_task_list)

        expect(retrieved_task_list.date).to eq task_list.date
      end
    end

    context 'when the tz offset results in different days' do
      it "retrieves today's task list" do
        date = DateTime.current.utc.beginning_of_day
        yesterday = DateTime.current.utc.beginning_of_day.advance(hours: -1).beginning_of_day

        # 2am UTC - EST is either -4 or -5 so this should be 'yesterday' for the user
        time_user_requested_task_list = date.advance(hours: 2)

        today_task_list = create(:task_list, date:, user:)
        yesterday_task_list = create(:task_list, date: yesterday, user:)

        retrieved_task_list = described_class.new(user:).call(today: time_user_requested_task_list)

        expect(retrieved_task_list.id).not_to eq today_task_list.id
        expect(retrieved_task_list.date).to eq yesterday_task_list.date
      end
    end
  end

  context 'when the user lives in a positive offset from UTC' do
    let!(:user) { create(:user, time_zone: 'Europe/Moscow') }

    context 'when the tz offset results in the same day' do
      it "retrieves today's task list" do
        date = DateTime.current.utc.beginning_of_day

        # 8PM UTC - Moscow is +3
        time_user_requested_task_list = date.advance(hours: 20)

        task_list = create(:task_list, date:, user:)

        retrieved_task_list = described_class.new(user:).call(today: time_user_requested_task_list)

        expect(retrieved_task_list.date).to eq task_list.date
      end
    end

    context 'when the tz offset results in different days' do
      it "retrieves today's task list" do
        date = DateTime.current.utc.beginning_of_day
        tomorrow = DateTime.current.utc.end_of_day.advance(hours: 1).beginning_of_day

        # 10pm UTC - Moscow is +3 so this should be 'tomorrow' for the user
        time_user_requested_task_list = date.advance(hours: 22)

        today_task_list = create(:task_list, date:, user:)
        tomorrow_task_list = create(:task_list, date: tomorrow, user:)

        retrieved_task_list = described_class.new(user:).call(today: time_user_requested_task_list)

        expect(retrieved_task_list.id).not_to eq today_task_list.id
        expect(retrieved_task_list.date).to eq tomorrow_task_list.date
      end
    end
  end
end
