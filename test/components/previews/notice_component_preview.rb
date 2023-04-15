# frozen_string_literal: true

class NoticeComponentPreview < ViewComponent::Preview
  def default(message: 'Hello, world!')
    render(Alerts::NoticeComponent.new(message:))
  end
end
