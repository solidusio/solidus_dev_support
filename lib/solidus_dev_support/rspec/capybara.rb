# frozen_string_literal: true

# Allow to override the initial windows size
CAPYBARA_WINDOW_SIZE = (ENV['CAPYBARA_WINDOW_SIZE'] || '1920x1080').split('x', 2).map(&:to_i)

Capybara.javascript_driver = (ENV['CAPYBARA_JAVASCRIPT_DRIVER'] || "solidus_chrome_headless").to_sym
Capybara.default_max_wait_time = 10
Capybara.server = :puma, { Silent: true } # A fix for rspec/rspec-rails#1897

Capybara.drivers[:selenium_chrome_headless].tap do |original_driver|
  Capybara.register_driver :solidus_chrome_headless do |app|
    original_driver.call(app).tap do |driver|
      driver.options[:options].args << "--window-size=#{CAPYBARA_WINDOW_SIZE.join(',')}"
    end
  end
end

require 'spree/testing_support/capybara_ext'
