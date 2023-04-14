# frozen_string_literal: true

is_ci = ENV.fetch('IS_CI', false)
Rails.logger.info("is_ci = #{is_ci}")

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    args: %w[headless no-sandbox disable-gpu disable-dev-shm-usage],
    binary: '/usr/bin/google-chrome'
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

RSpec.configure do |config|
  if is_ci
    config.before(:each, type: :system) do
      Rails.logger.info('Running system test with headless chrome')
      driven_by :headless_chrome
      # driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
    end
  end
end
