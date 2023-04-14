# frozen_string_literal: true

Capybara.register_driver :selenium_chrome_headless do |app|
  version = Capybara::Selenium::Driver.load_selenium
  options_key = Capybara::Selenium::Driver::CAPS_VERSION.satisfied_by?(version) ? :capabilities : :options
  browser_options = Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.add_argument('--headless')
    opts.add_argument('--disable-gpu') if Gem.win_platform?
    # Workaround https://bugs.chromium.org/p/chromedriver/issues/detail?id=2650&q=load&sort=-id&colspec=ID%20Status%20Pri%20Owner%20Summary
    opts.add_argument('--disable-site-isolation-trials')
    opts.add_preference('download.default_directory', Capybara.save_path)
    opts.add_preference(:download, default_directory: Capybara.save_path)
  end

  client = Selenium::WebDriver::Remote::Http::Default.new
  client.open_timeout = 120
  client.read_timeout = 120
  Capybara::Selenium::Driver.new(app, **{ browser: :chrome, http_client: client, options_key => browser_options })
end

RSpec.configure do |config|
  is_ci = ENV.fetch('IS_CI', false)
  if is_ci
    config.before(:each, type: :system) do
      driven_by :selenium_chrome_headless
    end
  end
end
