# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Alerts::NoticeComponent, type: :component do
  let(:message) { 'Hello, world!' }
  let(:notice_component) do
    described_class.new(message:)
  end

  it 'renders component' do
    render_inline(notice_component)
    expect(page).to have_text message
  end
end
