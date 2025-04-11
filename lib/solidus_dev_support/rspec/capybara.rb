# frozen_string_literal: true

require "selenium-webdriver"

# Allow to override the initial windows size
CAPYBARA_WINDOW_SIZE = ENV.fetch('CAPYBARA_WINDOW_SIZE', '1920x1080')

# Set Chrome version you want to use
CAPYBARA_JAVASCRIPT_DRIVER_VERSION = ENV.fetch('CAPYBARA_JAVASCRIPT_DRIVER_VERSION', "133")

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
    opts.add_argument("--disable-backgrounding-occluded-windows")
    opts.browser_version = CAPYBARA_JAVASCRIPT_DRIVER_VERSION
  end
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end

require 'capybara-screenshot/rspec'

Capybara::Screenshot.register_driver(:solidus_chrome_headless) do |driver, path|
  driver.browser.save_screenshot(path)
end

require 'spree/testing_support/capybara_ext'
