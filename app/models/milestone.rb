# frozen_string_literal: true

class Milestone < ApplicationRecord
  belongs_to :goal, class_name: 'Goals::Goal'
  validates :name, :description, presence: true
  validate :completed_at, :validate_completed_at

  def active?
    completed == true
  end

  def inactive?
    completed == false
  end

  class << self
    def policy_class
      MilestonePolicy
    end
  end

  private

  def validate_completed_at
    is_completed = completed == true
    errors.add(:completed_at, 'must be set when completed') if is_completed && completed_at.nil?
  end
end
