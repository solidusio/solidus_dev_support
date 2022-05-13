# frozen_string_literal: true

require 'webdrivers/chromedriver'

# Allow to override the initial windows size
CAPYBARA_WINDOW_SIZE = (ENV['CAPYBARA_WINDOW_SIZE'] || '1920x1080').split('x', 2).map(&:to_i)

Capybara.javascript_driver = (ENV['CAPYBARA_JAVASCRIPT_DRIVER'] || "solidus_chrome_headless").to_sym
Capybara.default_max_wait_time = 10
Capybara.server = :puma, { Silent: true } # A fix for rspec/rspec-rails#1897

chrome_options = Selenium::WebDriver::Chrome::Options.new.tap do |options|
  options.add_argument("--window-size=#{CAPYBARA_WINDOW_SIZE.join(',')}")
  options.add_argument("--headless")
  options.add_argument("--disable-gpu")
end

options_key = Capybara::Selenium::Driver::CAPS_VERSION.satisfied_by?(version) ? :capabilities : :options

Capybara.register_driver :solidus_chrome_headless do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, options_key => chrome_options)
end

require 'spree/testing_support/capybara_ext'
