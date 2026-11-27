# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdhocTasks' do
  let!(:user) { create(:user) }
  let!(:task_list) { create(:task_list, user:) }

  describe 'new page' do
    context 'when user is not authenticated' do
      it 'redirects to sign-in' do
        visit new_adhoc_task_path
        expect(page).to have_current_path('/users/sign_in')
      end
    end

    context 'when the user is authenticated' do
      before do
        sign_in user
      end

      it 'can view the form to create an adhoc task' do
        visit new_adhoc_task_path
        expect(page).to have_current_path(new_adhoc_task_path)
      end

      it 'displays an error when name is empty' do
        visit new_adhoc_task_path

        fill_in 'Name', with: ''
        submit_button = find('input[name="commit"]')
        submit_button.click

        expect(page).not_to have_content(I18n.t('helpers.alert.update_successful', name: ''))
        expect(page).to have_content("Name can't be blank")
      end

      it 'can create an ad hoc task' do
        name = Faker::Lorem.word
        visit new_adhoc_task_path(task_list_id: task_list.id)

        fill_in 'Name', with: name
        submit_button = find('input[name="commit"]')
        submit_button.click

        expect(page).to have_current_path(tasks_path(task_list_id: task_list.id))
        expect(page).to have_content(I18n.t('helpers.alert.create_successful', name:))
        expect(page).to have_content(name)
      end
    end
  end

  describe 'deleting' do
    # The task list is only shown to users with goals. Creating a goal rebuilds today's task list
    let!(:goal) { create(:daily_goal, user:) }
    let(:todays_task_list) { TaskList.find_by!(user:, date: user.beginning_of_day) }
    let!(:adhoc_task) { create(:adhoc_task, user:, task_list: todays_task_list, position: 1) }

    before do
      sign_in user
      visit tasks_path
    end

    it 'can delete an ad hoc task' do
      accept_confirm(I18n.t('tasks.adhoc.destroy.confirmation', name: adhoc_task.name)) do
        click_on I18n.t('tasks.adhoc.destroy.label', name: adhoc_task.name)
      end

      expect(page).to have_content(I18n.t('tasks.adhoc.destroy.success', name: adhoc_task.name))
      expect(page).to have_no_css("#task-list-item-#{adhoc_task.id}")
      expect(Tasks::AdhocTask.exists?(adhoc_task.id)).to be(false)
    end

    it 'keeps the task, not completed, when the delete is cancelled' do
      dismiss_confirm do
        click_on I18n.t('tasks.adhoc.destroy.label', name: adhoc_task.name)
      end

      expect(page).to have_css("#task-list-item-#{adhoc_task.id}")
      expect(find("input[data-task-id='#{adhoc_task.id}']")).not_to be_checked
      expect(adhoc_task.reload.completed).to be(false)
    end

    it 'does not show a delete button on goal tasks' do
      goal_task = todays_task_list.goal_tasks.first

      expect(page).to have_css("#task-list-item-#{goal_task.id}")
      expect(page).to have_no_button(I18n.t('tasks.adhoc.destroy.label', name: goal.name))
    end
  end
end
