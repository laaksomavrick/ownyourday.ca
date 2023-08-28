# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TaskPosition' do
  let!(:user) { create(:user) }
  let!(:goal_one) { create(:daily_goal, user:, position: 0) }
  let!(:goal_two) { create(:daily_goal, user:, position: 1) }

  describe 'update' do
    # Need to figure out how to emulate click-and-hold for 500ms
    # rubocop:disable RSpec/PendingWithoutReason
    xit 'can update a task position' do
    # rubocop:enable RSpec/PendingWithoutReason
      sign_in user
      visit tasks_path

      task_one = Tasks::GoalTask.where(goal: goal_one).first
      task_two = Tasks::GoalTask.where(goal: goal_two).first

      source = page.find("#task-list-item-#{task_one.id}")
      target = page.find("#task-list-item-#{task_two.id}")

      source.drag_to(target)

      task_one = Tasks::GoalTask.where(goal: goal_one).first
      task_two = Tasks::GoalTask.where(goal: goal_two).first

      task_one_form = page.find("#task-#{task_one.id}-position-form", visible: false)
      task_two_form = page.find("#task-#{task_two.id}-position-form", visible: false)

      expect(task_one.position).to be(1)
      within task_one_form do
        position_input = find('input[name="task_position[position]"]', visible: false)
        expect(position_input.value).to eq(1.to_s)
      end

      expect(task_two.position).to be(0)
      within task_two_form do
        position_input = find('input[name="task_position[position]"]', visible: false)
        expect(position_input.value).to eq(0.to_s)
      end
    end
  end
end
