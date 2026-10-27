# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks' do
  include ActiveSupport::Testing::TimeHelpers

  describe 'index' do
    # Monday is 0
    let(:tuesday) { 1 }
    let(:wednesday) { 2 }

    [
      ['America/Toronto', [2026, 10, 27, 20, 30]],
      ['America/Toronto', [2026, 10, 27, 23, 59]],
      ['America/Toronto', [2026, 10, 27, 0, 30]],
      ['Europe/Moscow', [2026, 10, 27, 0, 30]],
      ['Europe/Moscow', [2026, 10, 27, 10, 0]],
      ['Asia/Tokyo', [2026, 10, 27, 8, 0]],
      ['UTC', [2026, 10, 27, 23, 0]]
    ].each do |time_zone, local_time|
      context "when it is Tuesday #{local_time[3]}:#{local_time[4]} in #{time_zone}" do
        let!(:user) { create(:user, time_zone:) }

        before do
          create(:days_of_week_goal, user:, name: 'tuesday-goal', metadata: { 'days_of_week' => [tuesday] })
          create(:days_of_week_goal, user:, name: 'wednesday-goal', metadata: { 'days_of_week' => [wednesday] })
          sign_in user
        end

        it "shows today's date and today's tasks for the user's time zone" do
          travel_to Time.find_zone(time_zone).local(*local_time) do
            get tasks_path
          end

          expect(response.body).to include('Oct 27, 2026')
          expect(response.body).to include('tuesday-goal')
          expect(response.body).not_to include('wednesday-goal')
        end
      end
    end
  end
end
