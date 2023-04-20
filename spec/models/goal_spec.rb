# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Goal do
  it 'can create a goal' do
    exercise = create(:goal)
    expect(exercise.valid?).to be(true)
  end

  it 'requires a name' do
    expect do
      create(:goal, name: '')
    end.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
  end
end
