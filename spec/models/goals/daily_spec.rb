# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Goals::Daily do
  it 'can create a daily goal' do
    goal = create(:daily_goal)
    expect(goal.valid?).to be(true)
  end

  it 'requires a name' do
    expect do
      create(:daily_goal, name: '')
    end.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
  end

  it 'must have default metadata' do
    expect do
      create(:daily_goal, metadata: { 'foo' => 'bar' })
    end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Metadata is invalid')
  end

  context 'when modified' do
    let!(:user) { create(:user) }
    let!(:goal) { create(:daily_goal, user:) }

    before do
      GenerateTodaysTaskListAction.new(user:).call
    end

    it 'adds a task when a goal is created' do
      goal_two = create(:daily_goal, user:)
      task_list = user.task_lists.first

      expect(task_list.tasks.count).to eq 2
      expect(task_list.tasks.find_by(goal_id: goal_two.id)).not_to be_nil
    end

    it 'removes a task when a goal is deleted' do
      goal.destroy

      task_list = user.task_lists.first

      expect(task_list.tasks.count).to eq 0
    end

    it 'updates a task when a goal is modified' do
      goal.name = 'foo'
      goal.save

      task_list = user.task_lists.first

      expect(task_list.tasks.count).to eq 1
      expect(task_list.tasks.find_by(goal_id: goal.id).name).to eq 'foo'
    end
  end
end
