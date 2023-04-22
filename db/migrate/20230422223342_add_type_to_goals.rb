# frozen_string_literal: true

class AddTypeToGoals < ActiveRecord::Migration[7.0]
  def change
    add_column :goals, :type, :string
    add_column :goals, :metadata, :jsonb, null: false, default: '{}'
  end
end
