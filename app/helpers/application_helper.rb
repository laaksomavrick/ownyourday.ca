# frozen_string_literal: true

module ApplicationHelper
  def brand_color
    'indigo'
  end

  # rubocop:disable Layout/LineLength
  def primary_button(css = '')
    "bg-indigo-500 hover:bg-indigo-400 text-white font-bold py-2 px-4 rounded shadow hover:shadow-md cursor-pointer #{css}"
  end
  # rubocop:enable Layout/LineLength

  def primary_button_disabled(css = '')
    "bg-indigo-200 text-white font-bold py-2 px-4 rounded cursor-not-allowed h-fit shadow #{css}"
  end

  def destroy_button(css = '')
    "bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded cursor-pointer shadow hover:shadow-md #{css}"
  end

  # rubocop:disable Layout/LineLength
  def neutral_button(css = '')
    "bg-transparent hover:bg-indigo-500 text-indigo-500 font-semibold hover:text-white py-2 px-4 border border-gray-300 hover:border-transparent rounded shadow hover:shadow-md #{css}"
  end
  # rubocop:enable Layout/LineLength

  def date_is_user_today?(datetime: DateTime.current.utc)
    user_date = datetime.in_time_zone(current_user.time_zone)
    user_date.today?
  end

  def human_date_string(datetime: DateTime.current.utc)
    datetime.strftime('%b %d, %Y')
  end

  def user_initials(user: nil)
    user ||= current_user
    first_name = user.first_name
    last_name = user.last_name

    return 'NA' if first_name.empty? && last_name.empty?

    "#{first_name.first}#{last_name.first}"
  end
end
