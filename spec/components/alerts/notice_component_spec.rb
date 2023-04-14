# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Alerts::NoticeComponent, type: :component do
  let(:message) { 'Hello, world!' }
  let(:subject) do
    described_class.new(message:)
  end

  it 'renders component' do
    render_inline(subject)
    expect(page).to have_text message
  end
end
