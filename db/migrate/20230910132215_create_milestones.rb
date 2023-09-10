# frozen_string_literal: true

class CreateMilestones < ActiveRecord::Migration[7.0]
  def change
    create_table :milestones do |t|
      t.references :goal
      t.string :name, null: false, default: ''
      t.string :description, null: false, default: ''
      t.boolean :completed, null: false, default: false
      t.timestamp :completed_at, null: true
      t.timestamps
    end
  end
end
