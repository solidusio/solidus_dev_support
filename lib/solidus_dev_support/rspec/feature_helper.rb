# frozen_string_literal: true

# A basic feature_helper to be included as the starting point for extensions
#
# Can be required from an extension's spec/feature_helper.rb
#
#     require 'solidus_dev_support/rspec/feature_helper'
#

require 'solidus_dev_support/rspec/rails_helper'

require 'capybara-screenshot/rspec'
require 'capybara/apparition'

Capybara.javascript_driver = (ENV['CAPYBARA_DRIVER'] || :apparition).to_sym
Capybara.default_max_wait_time = 10
Capybara.server = :puma, { Silent: true } # A fix for rspec/rspec-rails#1897

Capybara.register_driver :apparition do |app|
  Capybara::Apparition::Driver.new(app, window_size: [1920, 1080])
end

require 'spree/testing_support/capybara_ext'

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
