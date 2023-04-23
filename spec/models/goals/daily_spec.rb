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
end
