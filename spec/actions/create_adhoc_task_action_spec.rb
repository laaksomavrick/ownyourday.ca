# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateAdhocTaskAction do
  let!(:user) { create(:user) }
  let!(:task_list) { create(:task_list, user:) }

  it 'sets position to be the last entry of the task list tasks' do
    params = { task_list_id: task_list.id, name: 'foo', user: }
    task_one = described_class.new.call(adhoc_task_params: params)
    task_two = described_class.new.call(adhoc_task_params: params)
    task_three = described_class.new.call(adhoc_task_params: params)

    expect(task_one.position).to be(0)
    expect(task_two.position).to be(1)
    expect(task_three.position).to be(2)
  end
end
