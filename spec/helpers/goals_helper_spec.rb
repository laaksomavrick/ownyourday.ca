# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GoalsHelper do
  describe 'times_per_week_schedule_message' do
    it 'uses singular time' do
      message = times_per_week_schedule_message(1)
      expect(message).to include I18n.t('common.time')
    end

    it 'uses pluralized times' do
      message = times_per_week_schedule_message(2)
      expect(message).to include I18n.t('common.times')
    end
  end

  describe 'days_of_week_schedule_message' do
    it 'is not scheduled when no days provided' do
      message = days_of_week_schedule_message
      expect(message).to eq t('goal.schedule.day_of_week_none_summary')
    end

    it 'is one word when one day provided' do
      message = days_of_week_schedule_message([0])
      expect(message).to include t('days_of_week.monday')
      expect(message).not_to include t('common.and')
      expect(message).not_to include ','
    end

    it 'is a conjugative when two days provided' do
      t('goal.schedule.day_of_week_none_summary')
      message = days_of_week_schedule_message([1, 2])
      expect(message).to include t('days_of_week.tuesday')
      expect(message).to include t('days_of_week.wednesday')
      expect(message).to include t('common.and')
      expect(message).not_to include ','
    end

    it 'is a list when three or more days provided' do
      message = days_of_week_schedule_message([1, 2, 4])
      expect(message).to include t('days_of_week.tuesday')
      expect(message).to include t('days_of_week.wednesday')
      expect(message).to include t('days_of_week.friday')
      expect(message).to include t('common.and')
      expect(message).to include ','
    end
  end
end
