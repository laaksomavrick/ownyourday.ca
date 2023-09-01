# frozen_string_literal: true

is_ci = ENV.fetch('IS_CI', false)

Capybara.enable_aria_label = true

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    args: %w[headless no-sandbox disable-gpu disable-dev-shm-usage],
    binary: '/usr/bin/google-chrome'
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options:
  )
end

RSpec.configure do |config|
  if is_ci
    config.before(:each, type: :system) do
      driven_by :headless_chrome
    end
  end
end
