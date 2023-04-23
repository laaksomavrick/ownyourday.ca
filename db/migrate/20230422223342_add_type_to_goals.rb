# frozen_string_literal: true

class AddTypeToGoals < ActiveRecord::Migration[7.0]
  def change
    # rubocop:disable Rails/BulkChangeTable
    add_column :goals, :type, :string
    # rubocop:enable Rails/BulkChangeTable
    add_column :goals, :metadata, :jsonb, null: false, default: '{}'
  end
end
