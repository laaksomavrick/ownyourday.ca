# frozen_string_literal: true

module ApplicationHelper
  def brand_color
    'teal'
  end

  def primary_button(css = '')
    "bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded cursor-pointer h-fit #{css}"
  end

  def destroy_button(css_class_string = '')
    "bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded cursor-pointer #{css_class_string}"
  end
end
