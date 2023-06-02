# frozen_string_literal: true

# rubocop:disable Rspec/NestedGroups

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

    context 'when user is authenticated' do
      before do
        sign_in user
      end

      describe 'task completion' do
        it 'can complete a task' do
          visit tasks_path

          task = user.tasks.first
          task_id = task.id

          task_check_box = find("input[data-task-id='#{task_id}']")

          task_check_box.click

          expect(task_check_box).to be_checked
        end

        it 'can uncomplete a task' do
          visit tasks_path

          task = user.tasks.first
          task_id = task.id

          task_check_box = find("input[data-task-id='#{task_id}']")

          task_check_box.click
          task_check_box.click

          expect(task_check_box).not_to be_checked
        end
      end

      describe 'task list selection' do
        let!(:today) { user.beginning_of_day }
        let!(:yesterday) { today.yesterday }
        let!(:task_list) { create(:task_list, user:, date: yesterday) }

        context 'when using a task_list_id param' do
          it 'redirects to default date (today) when task list not found' do
            not_found_task_list_id = task_list.id + 1

            visit tasks_path(task_list_id: not_found_task_list_id)

            expect(page).to have_current_path(tasks_path)

            expect(page).to have_content(today.year)
            expect(page).to have_content(today.strftime('%B'))
            expect(page).to have_content(today.day)
          end

          it 'can display a task list by id' do
            visit tasks_path(task_list_id: task_list.id)

            expect(page).to have_current_path(tasks_path(task_list_id: task_list.id))

            expect(page).to have_content(yesterday.year)
            expect(page).to have_content(yesterday.strftime('%B'))
            expect(page).to have_content(yesterday.day)
          end
        end

        context 'when using the date picker' do
          it "shows today's date by default" do
            visit tasks_path

            expect(page).to have_content(today.year)
            expect(page).to have_content(today.strftime('%B'))
            expect(page).to have_content(today.day)
          end

          it 'can pick a date to display tasks for' do
            monday_only_goal = create(:days_of_week_goal, user:, metadata: { 'days_of_week' => [0] })
            not_monday_goal = create(:days_of_week_goal, user:,
                                                         metadata: { 'days_of_week' => [1, 2, 3, 4, 5, 6] })

            monday = user.beginning_of_day.beginning_of_week

            visit tasks_path

            click_button user.beginning_of_day.strftime('%B %d, %Y')

            select monday.year.to_s, from: 'task_list[date(1i)]'
            select monday.strftime('%B'), from: 'task_list[date(2i)]'
            select monday.day.to_s, from: 'task_list[date(3i)]'
            click_button I18n.t('tasks.date.button')

            find_button(text: monday.strftime('%B %d, %Y'))

            expect(page).to have_content(monday.year)
            expect(page).to have_content(monday.strftime('%B'))
            expect(page).to have_content(monday.day)

            expect(page).to have_content(monday_only_goal.name)
            expect(page).not_to have_content(not_monday_goal.name)
          end
        end
      end

      it 'shows a user\'s tasks' do
        visit tasks_path
        expect(page).to have_content(goals.first.name)
        expect(page).to have_current_path('/tasks')
      end
    end
  end
end

# rubocop:enable Rspec/NestedGroups
