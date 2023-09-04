# frozen_string_literal: true

module ApplicationHelper
  def brand_color
    'teal'
  end

  def primary_button(css = '')
    "bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded cursor-pointer h-fit #{css}"
  end

  def destroy_button(css = '')
    "bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded cursor-pointer #{css}"
  end

  # rubocop:disable Layout/LineLength
  def neutral_button(css = '')
    "bg-transparent hover:bg-blue-500 text-blue-700 font-semibold hover:text-white py-2 px-4 border border-gray-300 hover:border-transparent rounded #{css}"
  end
  # rubocop:enable Layout/LineLength

  def human_date_string(datetime: DateTime.current.utc)
    datetime.strftime('%b %d, %Y')
  end
end
