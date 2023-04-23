# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Goals::DaysOfWeek do
  it 'can create a days_of_week goal' do
    goal = create(:days_of_week_goal)
    expect(goal.valid?).to be(true)
  end

  it 'requires a name' do
    expect do
      create(:days_of_week_goal, name: '')
    end.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
  end

  it 'cannot have no scheduled days' do
    expect do
      create(:days_of_week_goal, metadata: { 'days_of_week' => [] })
    end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Days of week has no days specified')
  end

  it 'must not have duplicate day of week entries' do
    expect do
      create(:days_of_week_goal, metadata: { 'days_of_week' => [0, 1, 1, 2] })
    end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Days of week has duplicate days')
  end

  it 'must have day of week entries between 0 and 6' do
    expect do
      create(:days_of_week_goal, metadata: { 'days_of_week' => [0, 3, 6, 7] })
    end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Days of week has invalid days')
  end
end
