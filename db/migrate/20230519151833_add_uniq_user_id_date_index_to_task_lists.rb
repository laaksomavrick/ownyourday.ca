class AddUniqUserIdDateIndexToTaskLists < ActiveRecord::Migration[7.0]
  def change
    add_index :task_lists, %i[user_id date], unique: true
  end
end
