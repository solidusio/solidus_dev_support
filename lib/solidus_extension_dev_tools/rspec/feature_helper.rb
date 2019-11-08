# frozen_string_literal: true

# A basic feature_helper to be included as the starting point for extensions
#
# Can be required from an extension's spec/feature_helper.rb
#
#     require 'solidus_extension_dev_tools/extension/feature_helper'
#

require 'solidus_extension_dev_tools/rspec/rails_helper'

require 'capybara-screenshot/rspec'
require 'selenium/webdriver'

Capybara.register_driver :selenium_chrome_headless do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless start-maximized] }
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: capabilities
  )
end

Capybara.javascript_driver = (ENV['CAPYBARA_DRIVER'] || :selenium_chrome_headless).to_sym
Capybara.default_max_wait_time = 10
Capybara.server = :webrick

require 'spree/testing_support/capybara_ext'

RSpec.configure do |config|
  config.when_first_matching_example_defined(type: :feature) do
    config.before :suite do
      # Preload assets
      if Rails.application.respond_to?(:precompiled_assets)
        Rails.application.precompiled_assets
      else
        # For older sprockets 2.x
        Rails.application.config.assets.precompile.each do |asset|
          Rails.application.assets.find_asset(asset)
        end
      end
    end
  end
end
