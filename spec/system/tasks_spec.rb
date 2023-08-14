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

          visit tasks_path
          task_check_box = find("input[data-task-id='#{task_id}']")

          task_check_box.click

          visit tasks_path
          task_check_box = find("input[data-task-id='#{task_id}']")

          expect(task_check_box).not_to be_checked
        end
      end

      describe 'task list selection' do
        let!(:today) { user.beginning_of_day }
        let!(:yesterday) { today.yesterday }

        context 'when using a task_list_id param' do
          let!(:task_list) { create(:task_list, user:, date: yesterday) }

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

      describe 'task list item context' do
        SpecConstants::TIME_ZONES.each do |time_zone|
          let!(:user) { create(:user, time_zone:) }
          let!(:goal) { create(:times_per_week_goal, user:, metadata: { 'times_per_week' => 3 }) }

          it "shows task context when there are no completions this week for timezone #{time_zone}" do
            visit tasks_path
            expect(page).to have_content('0 / 3')
          end

          it "shows task context when there are some completions this week for timezone #{time_zone}" do
            monday = user.beginning_of_day.monday
            tuesday = monday + 1.day
            wednesday = monday + 2.days

            monday_task_list = GenerateTodaysTaskListAction
                               .new(user:)
                               .call(today: monday)
            tuesday_task_list = GenerateTodaysTaskListAction
                                .new(user:)
                                .call(today: tuesday)
            monday_task_list.tasks.find_by(goal_id: goal.id).update(completed: true)
            tuesday_task_list.tasks.find_by(goal_id: goal.id).update(completed: true)

            visit tasks_path(task_list: { 'date(1i)' => wednesday.year, 'date(2i)' => wednesday.month,
                                          'date(3i)' => wednesday.day })

            expect(page).to have_content('2 / 3')
          end

          it "shows task completion when task was completed today for timezone #{time_zone}" do
            monday = user.beginning_of_day.monday
            monday_task_list = GenerateTodaysTaskListAction
                               .new(user:)
                               .call(today: monday)
            monday_task_list.tasks.find_by(goal_id: goal.id).update(completed: true)

            visit tasks_path(task_list: { 'date(1i)' => monday.year, 'date(2i)' => monday.month,
                                          'date(3i)' => monday.day })

            expect(page).to have_content('1 / 3')
          end
        end
      end

      describe 'goal deletion' do
        it 'deletes the corresponding task when a goal is deleted' do
          GenerateTodaysTaskListAction
            .new(user:)
            .call
          goal_to_delete = user.goals.first

          goal_to_delete.destroy!
          visit tasks_path

          expect(page).not_to have_content(goal_to_delete.name)
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
