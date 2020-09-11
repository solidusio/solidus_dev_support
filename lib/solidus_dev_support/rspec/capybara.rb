# frozen_string_literal: true

require 'capybara/apparition'

Capybara.javascript_driver = (ENV['CAPYBARA_DRIVER'] || :apparition).to_sym
Capybara.default_max_wait_time = 10
Capybara.server = :puma, { Silent: true } # A fix for rspec/rspec-rails#1897

Capybara.register_driver :apparition do |app|
  Capybara::Apparition::Driver.new(app, window_size: [1920, 1080])
end

require 'spree/testing_support/capybara_ext'
