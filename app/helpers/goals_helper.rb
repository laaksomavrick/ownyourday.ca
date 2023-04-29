# frozen_string_literal: true

module GoalsHelper
  DAY_OF_WEEK_WORD_MAPPING = {
    0 => I18n.t('days_of_week.monday'),
    1 => I18n.t('days_of_week.tuesday'),
    2 => I18n.t('days_of_week.wednesday'),
    3 => I18n.t('days_of_week.thursday'),
    4 => I18n.t('days_of_week.friday'),
    5 => I18n.t('days_of_week.saturday'),
    6 => I18n.t('days_of_week.sunday')
  }.freeze

  def times_per_week_schedule_message(times = 1)
    unit = times == 1 ? I18n.t('common.time') : I18n.t('commmon.times')
    I18n.t('goal.schedule.times_per_week_summary', times:, unit:)
  end

  def days_of_week_schedule_message(days = [])
    day_words = days.map { |day| DAY_OF_WEEK_WORD_MAPPING[day] }
    day_sentence = case day_words.length
                   when 1
                     day_words.first
                   when 2
                     "#{day_words.first} #{I18n.t('common.and')} #{day_words.second}"
                   else
                     last_day = day_words.pop
                     other_days = day_words.join(', ')
                     "#{other_days}, #{I18n.t('common.and')} #{last_day}"
                   end
    t('goal.schedule.day_of_week_summary', days: day_sentence)
  end
end
