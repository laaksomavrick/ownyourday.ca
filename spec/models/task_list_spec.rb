# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskList do
  it 'can create a task list' do
    task_list = create(:task_list)
    expect(task_list.valid?).to be(true)
  end

  it 'must have a date that is the start of the day' do
    expect do
      create(:task_list, date: DateTime.current.end_of_day)
    end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Date must be the start of the day')
  end

  it 'must only have one entry per date per user' do
    user = create(:user)
    date = DateTime.current.beginning_of_day
    expect do
      create(:task_list, user:, date:)
      create(:task_list, user:, date:)
    end.to raise_error(ActiveRecord::RecordNotUnique)
  end
end
