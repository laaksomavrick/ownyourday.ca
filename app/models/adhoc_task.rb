# frozen_string_literal: true

class AdhocTask < ApplicationRecord
  belongs_to :user
  belongs_to :task_list

  validates :name, presence: true

  class << self
    def policy_class
      AdhocTaskPolicy
    end
  end
end
