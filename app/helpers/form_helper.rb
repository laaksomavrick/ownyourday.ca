# frozen_string_literal: true

module FormHelper
  def label_class(css = '')
    "w-full text-md font-medium #{css}"
  end

  def text_field_class(css = '')
    "shadow hover:shadow-md w-full mt-2 outline-none rounded-md border-gray-300 placeholder-gray-300 focus:border-indigo-500 #{css}"
  end
end
