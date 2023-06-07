# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tasks::GoalTask do
  it 'can create a task' do
    task = create(:goal_task)
    expect(task.valid?).to be(true)
  end
end
