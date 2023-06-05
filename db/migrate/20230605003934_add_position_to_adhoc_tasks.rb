# frozen_string_literal: true

class AddPositionToAdhocTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :adhoc_tasks, :position, :integer
  end
end
