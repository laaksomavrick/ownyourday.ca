class AddPositionToGoals < ActiveRecord::Migration[7.0]
  def change
    add_column :goals, :position, :integer
  end
end
