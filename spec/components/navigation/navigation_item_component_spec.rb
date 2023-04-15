# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Navigation::NavigationItemComponent, type: :component do
  include ApplicationHelper

  subject(:navigation_item_component) do
    described_class.new(path:, title:)
  end

  let(:path) { 'path' }
  let(:title) { 'title' }

  it 'renders component' do
    render_inline(navigation_item_component)
    expect(page).to have_text title
  end

  context "when the current page is the navigation item's page" do
    before do
      # rubocop:disable RSpec/SubjectStub
      allow(navigation_item_component).to receive(:current_page?).and_return true
      # rubocop:enable RSpec/SubjectStub
    end

    it 'appears as active' do
      render_inline(navigation_item_component)
      expect(page).to have_css(".text-#{brand_color}-500")
    end
  end

  context "when the current page is not the navigation item's page" do
    before do
      # rubocop:disable RSpec/SubjectStub
      allow(navigation_item_component).to receive(:current_page?).and_return false
      # rubocop:enable RSpec/SubjectStub
    end

    it 'appears as active' do
      render_inline(navigation_item_component)
      expect(page).to have_css(".text-#{brand_color}-300")
    end
  end
end
