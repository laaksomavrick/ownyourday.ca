class Milestone < ApplicationRecord
  belongs_to :goal, class_name: 'Goals::Goal'
  validates :name, :description, presence: true

  def active?
    completed == true
  end

  def inactive?
    completed == false
  end
end
