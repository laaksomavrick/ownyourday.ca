# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tasks::AdhocTask do
  it 'can create a task' do
    adhoc_task = create(:adhoc_task)
    expect(adhoc_task.valid?).to be(true)
  end

  it 'requires a name' do
    expect do
      create(:adhoc_task, name: '')
    end.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
  end
end
