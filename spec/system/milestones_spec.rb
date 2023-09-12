# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Milestones' do
  let!(:user) { create(:user) }
  let!(:goal) { create(:daily_goal, user:) }

  describe 'index page' do
    context 'when unauthenticated' do
      it 'redirects to sign in' do
        visit goal_milestones_path(goal)
        expect(page).to have_current_path('/users/sign_in')
      end
    end

    context 'when authenticated' do
      before do
        sign_in user
      end

      it 'shows no_active milestone message' do
        visit goal_milestones_path(goal)
        expect(page).to have_content(I18n.t('milestones.no_active'))
      end

      it 'shows previously completed milestones' do
        completed_milestones = create_list(:milestone, 3, goal:, completed: true)

        visit goal_milestones_path(goal)

        expect(page).to have_content(I18n.t('milestones.no_active'))
        expect(page).to have_button(I18n.t('common.new'), disabled: false)
        expect(page).to have_content(completed_milestones.first.name)
        expect(page).to have_content(completed_milestones.second.name)
        expect(page).to have_content(completed_milestones.third.name)
      end

      it 'shows active milestone' do
        active_milestone = create(:milestone, goal:, completed: false)

        visit goal_milestones_path(goal)

        expect(page).to have_content(active_milestone.name)
        expect(page).to have_button(I18n.t('common.new'), disabled: true)
      end
    end
  end
end
