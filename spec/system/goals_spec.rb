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

  describe 'show page' do
    let!(:goal) { create(:daily_goal, user:) }

    it 'redirects non-authenticated users' do
      visit goal_path(goal.id)
      expect(page).to have_current_path('/users/sign_in')
    end

    it 'shows a goal' do
      sign_in user
      visit goal_path(goal.id)
      expect(page).to have_content(I18n.t('goal.header'))
    end
  end
end
