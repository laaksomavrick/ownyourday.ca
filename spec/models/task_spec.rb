# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task do
  it 'can create a task' do
    task = create(:task)
    expect(task.valid?).to be(true)
  end
end
