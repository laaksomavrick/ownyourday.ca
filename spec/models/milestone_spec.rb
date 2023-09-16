# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Milestone do
  it 'can create a milestone' do
    milestone = create(:milestone)
    expect(milestone.valid?).to be(true)
  end

  it 'requires a name' do
    expect do
      create(:milestone, name: '')
    end.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
  end

  it 'requires a description' do
    expect do
      create(:milestone, description: '')
    end.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Description can't be blank")
  end

  it 'requires completed_at when completed is true' do
    expect do
      create(:milestone, completed: true, completed_at: nil)
    end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Completed at must be set when completed')
  end
end
