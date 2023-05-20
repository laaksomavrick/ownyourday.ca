# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks' do
  let!(:user) { create(:user) }
  let!(:goals) { create_list(:daily_goal, 2, user:) }

  describe 'index page' do
    context 'when user is not authenticated' do
      it 'redirects to sign-in' do
        visit goals_path
        expect(page).to have_current_path('/users/sign_in')
      end
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
