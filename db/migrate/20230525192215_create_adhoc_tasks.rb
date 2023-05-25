# frozen_string_literal: true

class CreateAdhocTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :adhoc_tasks do |t|
      t.references :user
      t.references :task_list
      t.string :name, null: false, default: ''
      t.boolean :completed, null: false, default: false
      t.timestamps
    end
  end
end
