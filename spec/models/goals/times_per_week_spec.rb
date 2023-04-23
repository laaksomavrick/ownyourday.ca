# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Goals::TimesPerWeek do
  it 'can create a times_per_week goal' do
    goal = create(:times_per_week_goal)
    expect(goal.valid?).to be(true)
  end

  it 'requires a name' do
    expect do
      create(:times_per_week_goal, name: '')
    end.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
  end

  it 'cannot have times_per_week of less than 1' do
    expect do
      create(:times_per_week_goal, metadata: { 'times_per_week' => 0 })
    end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Times per week must be greater than 0')
  end

  it 'cannot have times_per_week greater than week length' do
    expect do
      create(:times_per_week_goal, metadata: { 'times_per_week' => 7 })
    end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Times per week must be less than 7')
  end
end
