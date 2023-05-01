# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Goals' do
  let!(:user) { create(:user) }
  let!(:goals) { create_list(:daily_goal, 2, user:) }

  describe 'index page' do
    it 'redirects non-authenticated users' do
      visit goals_path
      expect(page).to have_current_path('/users/sign_in')
    end

    it 'shows a user\'s exercises' do
      sign_in user
      visit goals_path
      expect(page).to have_content(goals.first.name)
      expect(page).to have_content(goals.second.name)
      expect(page).to have_current_path('/goals')
    end
  end

  describe 'edit page' do
    let!(:goal) { create(:daily_goal, user:) }

    it 'redirects non-authenticated users' do
      visit edit_goal_path(goal.id)
      expect(page).to have_current_path('/users/sign_in')
    end

    it 'shows a goal' do
      sign_in user
      visit edit_goal_path(goal.id)
      expect(page).to have_content(I18n.t('goal.header'))
    end

    context 'when using scheduling' do
      before do
        sign_in user
        visit edit_goal_path(goal.id)
      end

      it 'can use the daily schedule interface' do
        choose option: Goals::Daily.name
        expect(page).to have_content(I18n.t('goal.schedule.daily_summary'))
      end

      it 'can use the times per week interface' do
        choose option: Goals::TimesPerWeek.name
        select 2, from: 'goal_times_per_week'
        expect(page).to have_content(I18n.t('goal.schedule.times_per_week_summary', times: 2,
                                                                                    unit: I18n.t('common.times')))
      end

      it 'can use the days of week interface' do
        choose option: Goals::DaysOfWeek.name
        check 'goal[days_of_week][0]'
        check 'goal[days_of_week][1]'
        # rubocop:disable Layout/LineLength
        expect(page).to have_content(I18n.t('goal.schedule.day_of_week_summary', days: "#{I18n.t('days_of_week.monday')} #{I18n.t('common.and')} #{I18n.t('days_of_week.tuesday')}"))
        # rubocop:enable Layout/LineLength
      end
    end
  end
end
