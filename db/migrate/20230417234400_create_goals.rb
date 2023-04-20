# frozen_string_literal: true

class CreateGoals < ActiveRecord::Migration[7.0]
  def change
    create_table :goals do |t|
      t.string :name, null: false, default: ''
      t.references :user
      t.timestamps
    end
  end
end
