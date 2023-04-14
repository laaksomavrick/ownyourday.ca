# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Navigation::NavigationItemComponent, type: :component do
  include ApplicationHelper

  let(:path) { 'path' }
  let(:title) { 'title' }
  let(:subject) do
    described_class.new(path:, title:)
  end

  it 'renders component' do
    render_inline(subject)
    expect(page).to have_text title
  end

  context "when the current page is the navigation item's page" do
    before do
      allow(subject).to receive(:current_page?).and_return true
    end

    it 'appears as active' do
      render_inline(subject)
      expect(page).to have_css(".text-#{brand_color}-500")
    end
  end

  context "when the current page is not the navigation item's page" do
    before do
      allow(subject).to receive(:current_page?).and_return false
    end

    it 'appears as active' do
      render_inline(subject)
      expect(page).to have_css(".text-#{brand_color}-300")
    end
  end
end
