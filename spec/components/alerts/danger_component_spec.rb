# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Alerts::DangerComponent, type: :component do
  let(:message) { 'Oops! Something went wrong.' }
  let(:subject) do
    described_class.new(message:)
  end

  it 'renders component' do
    render_inline(subject)
    expect(page).to have_text message
  end
end
