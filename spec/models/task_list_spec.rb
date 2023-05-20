# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskList do
  SpecConstants::TIME_ZONES.each do |time_zone|
    context "when user is in #{time_zone} time zone" do
      let!(:user) { create(:user, time_zone:) }

      it 'can create a task list' do
        task_list = create(:task_list, user:)
        expect(task_list.valid?).to be(true)
      end

      it 'must only have one entry per date per user' do
        date = DateTime.current
        expect do
          create(:task_list, user:, date:)
          create(:task_list, user:, date:)
        end.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end
end
