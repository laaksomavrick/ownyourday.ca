# frozen_string_literal: true

module Tasks
  class AdhocTask < Tasks::Task
    validates :name, presence: true
  end
end
