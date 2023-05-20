# frozen_string_literal: true

class CreateTaskLists < ActiveRecord::Migration[7.0]
  def change
    create_table :task_lists do |t|
      t.references :user
      t.timestamp :date, null: false
      t.timestamps
    end
  end
end
