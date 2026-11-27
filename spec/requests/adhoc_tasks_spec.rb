# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdhocTasks' do
  let!(:user) { create(:user) }
  let!(:task_list) { create(:task_list, user:) }

  before { sign_in user }

  describe 'destroy' do
    it 'deletes an ad hoc task and redirects to its task list' do
      adhoc_task = create(:adhoc_task, user:, task_list:)

      expect { delete adhoc_task_path(adhoc_task) }.to change(Tasks::AdhocTask, :count).by(-1)

      expect(response).to redirect_to(tasks_path(task_list_id: task_list.id))
      expect(response).to have_http_status(:see_other)
      expect(flash[:notice]).to eq(I18n.t('tasks.adhoc.destroy.success', name: adhoc_task.name))
    end

    it 'closes the gap in task positions' do
      first = create(:adhoc_task, user:, task_list:, position: 0)
      second = create(:adhoc_task, user:, task_list:, position: 1)
      third = create(:adhoc_task, user:, task_list:, position: 2)

      delete adhoc_task_path(second)

      expect(task_list.tasks.reload.map { |task| [task.id, task.position] }).to eq([[first.id, 0], [third.id, 1]])
    end

    it "does not delete another user's ad hoc task" do
      other_user = create(:user)
      adhoc_task = create(:adhoc_task, user: other_user, task_list: create(:task_list, user: other_user))

      # Raised in tests; Rails responds with a 404 in production
      expect { delete adhoc_task_path(adhoc_task) }.to raise_error(ActiveRecord::RecordNotFound)
      expect(Tasks::AdhocTask.exists?(adhoc_task.id)).to be(true)
    end

    it 'does not delete a goal task' do
      # Creating a goal rebuilds today's task list with a task for the goal
      goal = create(:daily_goal, user:)
      goal_task = Tasks::GoalTask.find_by!(user:, goal:)

      expect { delete adhoc_task_path(goal_task) }.to raise_error(ActiveRecord::RecordNotFound)
      expect(Tasks::GoalTask.exists?(goal_task.id)).to be(true)
    end
  end
end
