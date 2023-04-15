# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Alerts::NoticeComponent do
  let(:message) { 'Hello, world!' }

  it 'can be dismissed' do
    visit("rails/view_components/notice_component/default?message=#{message}")
    expect(page).to have_text message
    find('span[aria-label="Close alert"]').click
    expect(page).not_to have_text message
  end
end
