# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks' do
  let!(:user) { create(:user) }
  let!(:goals) { create_list(:daily_goal, 2, user:) }

  describe 'index page' do
    context 'when user is not authenticated' do
      it 'redirects to sign-in' do
        visit tasks_path
        expect(page).to have_current_path('/users/sign_in')
      end
    end

    describe 'task list selection' do
      let!(:today) { user.beginning_of_day }
      let!(:yesterday) { today.yesterday }
      let!(:task_list) { create(:task_list, user:, date: yesterday) }

      # rubocop:disable RSpec/NestedGroups
      context 'when using a task_list_id param' do
        it 'redirects to default date (today) when task list not found' do
          not_found_task_list_id = task_list.id + 1

          sign_in user
          visit tasks_path(task_list_id: not_found_task_list_id)

          expect(page).to have_current_path(tasks_path)

          expect(page).to have_content(today.year)
          expect(page).to have_content(today.strftime('%B'))
          expect(page).to have_content(today.day)
        end

        it 'can display a task list by id' do
          sign_in user
          visit tasks_path(task_list_id: task_list.id)

          expect(page).to have_current_path(tasks_path(task_list_id: task_list.id))

          expect(page).to have_content(yesterday.year)
          expect(page).to have_content(yesterday.strftime('%B'))
          expect(page).to have_content(yesterday.day)
        end
      end

      context 'when using the date picker' do
        it "shows today's date by default" do
          sign_in user
          visit tasks_path

          expect(page).to have_content(today.year)
          expect(page).to have_content(today.strftime('%B'))
          expect(page).to have_content(today.day)
        end

        it 'can pick a date to display tasks for' do
          monday_only_goal = create(:days_of_week_goal, user:, metadata: { 'days_of_week' => [0] })
          not_monday_goal = create(:days_of_week_goal, user:, metadata: { 'days_of_week' => [1, 2, 3, 4, 5, 6] })

          monday = user.beginning_of_day.beginning_of_week

          sign_in user
          visit tasks_path

          click_button user.beginning_of_day.strftime('%B %d, %Y')

          select monday.day.to_s, from: 'task_list[date(3i)]'
          click_button I18n.t('tasks.date.button')

          expect(page).to have_content(monday.year)
          expect(page).to have_content(monday.strftime('%B'))
          expect(page).to have_content(monday.day)

          expect(page).to have_content(monday_only_goal.name)
          expect(page).not_to have_content(not_monday_goal.name)
        end
      end

      # rubocop:enable RSpec/NestedGroups
    end

    it 'shows a user\'s tasks' do
      sign_in user
      visit tasks_path
      expect(page).to have_content(goals.first.name)
      expect(page).to have_content(goals.second.name)
      expect(page).to have_current_path('/tasks')
    end
  end
end
