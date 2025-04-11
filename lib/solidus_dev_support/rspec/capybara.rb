# frozen_string_literal: true

require "selenium-webdriver"

# Allow to override the initial windows size
CAPYBARA_WINDOW_SIZE = ENV.fetch('CAPYBARA_WINDOW_SIZE', '1920x1080')

# Set Chrome version you want to use
CAPYBARA_JAVASCRIPT_DRIVER_VERSION = ENV.fetch('CAPYBARA_JAVASCRIPT_DRIVER_VERSION', "135")
# Make sure Selenium downloads this version of Chrome
ENV['SE_BROWSER_VERSION'] = CAPYBARA_JAVASCRIPT_DRIVER_VERSION

Capybara.javascript_driver = ENV.fetch('CAPYBARA_JAVASCRIPT_DRIVER', "solidus_chrome_headless").to_sym
Capybara.default_max_wait_time = 10
Capybara.server = :puma, { Silent: true } # A fix for rspec/rspec-rails#1897

Capybara.register_driver :solidus_chrome_headless do |app|
  browser_options = Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.add_argument("--headless=new")
    opts.add_argument("--disable-gpu")
    opts.add_argument("--no-sandbox")
    opts.add_argument("--window-size=#{CAPYBARA_WINDOW_SIZE}")
    opts.add_argument("--disable-search-engine-choice-screen")

    # From https://github.com/teamcapybara/capybara/issues/2796
    # Chrome flags found from:
    # - https://peter.sh/experiments/chromium-command-line-switches/
    # - https://github.com/GoogleChrome/chrome-launcher/blob/main/docs/chrome-flags-for-tools.md
    #
    # Disable timers being throttled in background pages/tabs. Useful for parallel test runs.
    opts.add_argument("disable-background-timer-throttling")
    # Normally, Chrome will treat a "foreground" tab instead as backgrounded if the surrounding window is occluded (aka
    # visually covered) by another window. This flag disables that. Useful for parallel test runs.
    opts.add_argument("disable-backgrounding-occluded-windows")
    # This disables non-foreground tabs from getting a lower process priority. Useful for parallel test runs.
    opts.add_argument("disable-renderer-backgrounding")

    opts.browser_version = CAPYBARA_JAVASCRIPT_DRIVER_VERSION
  end
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end

require 'capybara-screenshot/rspec'

Capybara::Screenshot.register_driver(:solidus_chrome_headless) do |driver, path|
  driver.browser.save_screenshot(path)
end

require 'spree/testing_support/capybara_ext'
