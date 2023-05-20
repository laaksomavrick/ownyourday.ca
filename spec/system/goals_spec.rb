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

    it 'shows a user\'s goals' do
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

    context 'when updating a goal' do
      before do
        sign_in user
        visit edit_goal_path(goal.id)
      end

      it 'updates a daily goal' do
        submit_button = find('input[name="commit"]')
        submit_button.click

        expect(page).to have_content(I18n.t('helpers.alert.update_successful', name: goal.name))
        expect(find_field('Name').value).to eq goal.name
        expect(find_by_id('goal_type_goalsdaily')).to be_checked
      end

      it 'updates a times_per_week goal' do
        select_option = 2.to_s

        choose option: Goals::TimesPerWeek.name
        select select_option, from: 'goal_times_per_week'
        submit_button = find('input[name="commit"]')
        submit_button.click

        expect(page).to have_content(I18n.t('helpers.alert.update_successful', name: goal.name))
        expect(find_field('Name').value).to eq goal.name
        expect(find_by_id('goal_times_per_week').value).to eq select_option
      end

      it 'updates a days_of_week goal' do
        choose option: Goals::DaysOfWeek.name
        check 'goal[days_of_week][0]'
        check 'goal[days_of_week][1]'
        submit_button = find('input[name="commit"]')
        submit_button.click

        expect(page).to have_content(I18n.t('helpers.alert.update_successful', name: goal.name))
        expect(find_field('Name').value).to eq goal.name
        expect(find_by_id('goal_days_of_week_0')).to be_checked
        expect(find_by_id('goal_days_of_week_1')).to be_checked
        expect(find_by_id('goal_days_of_week_2')).not_to be_checked
      end
    end

    context 'when validating inputs' do
      before do
        sign_in user
        visit edit_goal_path(goal.id)
      end

      it 'shows an error when name is empty' do
        fill_in 'Name', with: ''
        submit_button = find('input[name="commit"]')
        submit_button.click

        expect(page).not_to have_content(I18n.t('helpers.alert.update_successful', name: ''))
        expect(page).to have_content("Name can't be blank")
      end

      it 'shows an error when days_per_week is empty' do
        goal_name = 'goal name'

        fill_in 'Name', with: goal_name
        choose option: Goals::DaysOfWeek.name
        uncheck 'goal[days_of_week][0]'
        submit_button = find('input[name="commit"]')
        submit_button.click

        expect(page).not_to have_content(I18n.t('helpers.alert.update_successful', name: goal_name))
        expect(page).to have_content('Days of week has no days specified')
      end
    end

    context 'when deleting' do
      let!(:to_delete_goal) { create(:daily_goal, user:) }

      it 'can delete a goal' do
        sign_in user
        visit edit_goal_path(to_delete_goal.id)

        accept_confirm do
          click_button 'Delete'
        end

        expect(page).to have_content(I18n.t('goal.destroy.success', name: to_delete_goal.name))
      end
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

  describe 'create page' do
    it 'redirects non-authenticated users' do
      visit new_goal_path
      expect(page).to have_current_path('/users/sign_in')
    end

    context 'when creating a goal' do
      before do
        sign_in user
        visit new_goal_path
      end

      it 'creates a daily goal' do
        goal_name = 'goal name'

        fill_in 'Name', with: goal_name
        submit_button = find('input[name="commit"]')
        submit_button.click

        expect(page).to have_content(I18n.t('helpers.alert.create_successful', name: goal_name))
        expect(find_field('Name').value).to eq goal_name
        expect(find_by_id('goal_type_goalsdaily')).to be_checked
      end

      it 'creates a times_per_week goal' do
        goal_name = 'goal name'
        select_option = 2.to_s

        fill_in 'Name', with: goal_name
        choose option: Goals::TimesPerWeek.name
        select select_option, from: 'goal_times_per_week'
        submit_button = find('input[name="commit"]')
        submit_button.click

        expect(page).to have_content(I18n.t('helpers.alert.create_successful', name: goal_name))
        expect(find_field('Name').value).to eq goal_name
        expect(find_by_id('goal_times_per_week').value).to eq select_option
      end

      it 'creates a days_of_week goal' do
        goal_name = 'goal name'

        fill_in 'Name', with: goal_name
        choose option: Goals::DaysOfWeek.name
        check 'goal[days_of_week][0]'
        check 'goal[days_of_week][1]'
        submit_button = find('input[name="commit"]')
        submit_button.click

        expect(page).to have_content(I18n.t('helpers.alert.create_successful', name: goal_name))
        expect(find_field('Name').value).to eq goal_name
        expect(find_by_id('goal_days_of_week_0')).to be_checked
        expect(find_by_id('goal_days_of_week_1')).to be_checked
        expect(find_by_id('goal_days_of_week_2')).not_to be_checked
      end
    end

    context 'when validating inputs' do
      before do
        sign_in user
        visit new_goal_path
      end

      it 'shows an error when name is empty' do
        fill_in 'Name', with: ''
        submit_button = find('input[name="commit"]')
        submit_button.click

        expect(page).not_to have_content(I18n.t('helpers.alert.create_successful', name: ''))
        expect(page).to have_content("Name can't be blank")
      end

      it 'shows an error when days_per_week is empty' do
        goal_name = 'goal name'

        fill_in 'Name', with: goal_name
        choose option: Goals::DaysOfWeek.name
        uncheck 'goal[days_of_week][0]'
        submit_button = find('input[name="commit"]')
        submit_button.click

        expect(page).not_to have_content(I18n.t('helpers.alert.create_successful', name: goal_name))
        expect(page).to have_content('Days of week has no days specified')
      end
    end
  end
end
