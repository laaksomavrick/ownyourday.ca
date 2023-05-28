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
end
