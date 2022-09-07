# frozen_string_literal: true

# A basic feature_helper to be included as the starting point for extensions
#
# Can be required from an extension's spec/feature_helper.rb
#
#     require 'solidus_dev_support/rspec/feature_helper'
#

require 'solidus_dev_support/rspec/rails_helper'

require 'capybara-screenshot/rspec'
require 'solidus_dev_support/rspec/capybara'

Capybara::Screenshot.register_driver(:solidus_chrome_headless) do |driver, path|
  driver.browser.save_screenshot(path)
end

def dev_support_assets_preload
  if Rails.application.respond_to?(:precompiled_assets)
    Rails.application.precompiled_assets
  else
    # For older sprockets 2.x
    Rails.application.config.assets.precompile.each do |asset|
      Rails.application.assets.find_asset(asset)
    end
  end
end

RSpec.configure do |config|
  config.when_first_matching_example_defined(type: :feature) do
    config.before :suite do
      dev_support_assets_preload
    end
  end

  config.when_first_matching_example_defined(type: :system) do
    config.before :suite do
      dev_support_assets_preload
    end
  end
end
