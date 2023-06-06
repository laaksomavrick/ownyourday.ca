# frozen_string_literal: true

class AlterTasksToSti < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :type, :string
    add_column :tasks, :name, :string
    # rubocop:disable Lint/EmptyBlock
    drop_table :adhoc_tasks do |x|
    end
    # rubocop:enable Lint/EmptyBlock
  end
end
