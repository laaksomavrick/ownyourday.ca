# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.references :user
      t.references :goal
      t.references :task_list
      t.boolean :completed, null: false, default: false
      t.timestamps
    end
  end
end
