# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GoalPosition' do
  let!(:user) { create(:user) }
  let!(:goal_one) { create(:daily_goal, user:, position: 0) }
  let!(:goal_two) { create(:daily_goal, user:, position: 1) }

  describe 'update' do
    it 'can update a goal position' do
      sign_in user
      visit goals_path

      source = page.find("#goal-list-item-#{goal_one.id}")
      target = page.find("#goal-list-item-#{goal_two.id}")

      source.drag_to(target)

      goal_one_moved = Goals::Daily.find_by(id: goal_one.id)
      goal_two_moved = Goals::Daily.find_by(id: goal_two.id)

      goal_one_form = page.find("#goal-#{goal_one.id}-position-form", visible: false)
      goal_two_form = page.find("#goal-#{goal_two.id}-position-form", visible: false)

      expect(goal_one_moved.position).to be(1)
      within goal_one_form do
        position_input = find('input[name="goal_position[position]"]', visible: false)
        expect(position_input.value).to eq(1.to_s)
      end

      expect(goal_two_moved.position).to be(0)
      within goal_two_form do
        position_input = find('input[name="goal_position[position]"]', visible: false)
        expect(position_input.value).to eq(0.to_s)
      end
    end
  end
end
