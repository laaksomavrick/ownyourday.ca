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

  describe 'new page' do
    context 'when unauthenticated' do
      it 'redirects to sign in' do
        visit new_goal_milestone_path(goal)
        expect(page).to have_current_path('/users/sign_in')
      end
    end

    context 'when authenticated' do
      before do
        sign_in user
      end

      it 'can create a new milestone' do
        visit new_goal_milestone_path(goal)

        fill_in I18n.t('milestones.new.name_label'), with: 'name'
        fill_in I18n.t('milestones.new.description_label'), with: 'description'
        submit_button = find('input[name="commit"]')
        submit_button.click

        expect(page).to have_content(I18n.t('helpers.alert.create_successful', name: 'name'))
      end

      it 'causes an error when name is not set' do
        visit new_goal_milestone_path(goal)

        fill_in I18n.t('milestones.new.description_label'), with: 'description'
        submit_button = find('input[name="commit"]')
        submit_button.click

        expect(page).not_to have_content(I18n.t('helpers.alert.create_successful', name: 'name'))
        expect(page).to have_content("Name can't be blank")
      end

      it 'causes an error when description is not set' do
        visit new_goal_milestone_path(goal)

        fill_in I18n.t('milestones.new.name_label'), with: 'name'
        submit_button = find('input[name="commit"]')
        submit_button.click

        expect(page).not_to have_content(I18n.t('helpers.alert.create_successful', name: 'name'))
        expect(page).to have_content("Description can't be blank")
      end

      it 'causes an error when goal has an active milestone' do
        create(:milestone, goal:, completed: false)

        visit new_goal_milestone_path(goal)

        fill_in I18n.t('milestones.new.name_label'), with: 'name'
        fill_in I18n.t('milestones.new.description_label'), with: 'description'
        submit_button = find('input[name="commit"]')
        submit_button.click

        expect(page).to have_content(I18n.t('milestones.new.active_milestone_error'))
      end
    end
  end
end
