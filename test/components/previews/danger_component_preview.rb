# frozen_string_literal: true

class DangerComponentPreview < ViewComponent::Preview
  def default(message: 'Oops! Something went wrong.')
    render(Alerts::DangerComponent.new(message:))
  end
end
