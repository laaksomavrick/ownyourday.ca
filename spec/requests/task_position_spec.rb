# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TaskPosition' do
  let!(:user) { create(:user) }
  let!(:task_list) { create(:task_list, user:) }

  before { sign_in user }

  def move(task, to:)
    patch task_position_path(task),
          params: { task_position: { type: task.type, position: to } },
          as: :turbo_stream
  end

  def ordered_names
    task_list.tasks.reload.map(&:name)
  end

  describe 'update' do
    context 'when stored positions have gaps' do
      # Task lists are generated from goal positions, so a goal that isn't scheduled today leaves a gap
      let!(:first) { create(:adhoc_task, user:, task_list:, name: 'first', position: 0) }
      let!(:second) { create(:adhoc_task, user:, task_list:, name: 'second', position: 2) }
      let!(:third) { create(:adhoc_task, user:, task_list:, name: 'third', position: 5) }

      it 'moves a task to the dropped index' do
        move(third, to: 1)

        expect(response).to have_http_status(:ok)
        expect(ordered_names).to eq(%w[first third second])
      end

      it 'moves a task down to the dropped index' do
        move(first, to: 1)

        expect(ordered_names).to eq(%w[second first third])
      end

      it 'moves a task to the end of the list' do
        move(first, to: 2)

        expect(ordered_names).to eq(%w[second third first])
      end
    end

    it 'rejects an unknown task type' do
      task = create(:adhoc_task, user:, task_list:)

      patch task_position_path(task),
            params: { task_position: { type: 'User', position: 0 } },
            as: :turbo_stream

      expect(response).to have_http_status(:unprocessable_content)
    end
  end
end
