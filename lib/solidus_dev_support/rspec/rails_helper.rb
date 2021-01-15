# frozen_string_literal: true

# A basic rails_helper to be included as the starting point for extensions
#
# Can be required from an extension's spec/rails_helper.rb
#
#     require 'solidus_dev_support/rspec/rails_helper'
#

require 'solidus_dev_support/rspec/spec_helper'
require 'solidus_dev_support'

require 'rspec/rails'
require 'database_cleaner'
require 'factory_bot'
require 'ffaker'

require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/url_helpers'
require 'spree/testing_support/preferences'
require 'spree/testing_support/controller_requests'
require 'solidus_dev_support/testing_support/factories'
require 'solidus_dev_support/testing_support/preferences'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.include FactoryBot::Syntax::Methods

  # visit spree.admin_path
  # current_path.should eql(spree.products_path)
  config.include Spree::TestingSupport::UrlHelpers

  config.include Spree::TestingSupport::ControllerRequests, type: :controller

  config.include Spree::TestingSupport::Preferences
  config.include SolidusDevSupport::TestingSupport::Preferences

  config.before :suite do
    DatabaseCleaner.clean_with :truncation
  end

  config.before do
    ActiveJob::Base.queue_adapter = :test
  end

  # Around each spec check if it is a Javascript test and switch between using
  # database transactions or not where necessary.
  config.around(:each) do |example|
    DatabaseCleaner.strategy = RSpec.current_example.metadata[:js] ? :truncation : :transaction

    DatabaseCleaner.cleaning do
      reset_spree_preferences unless SolidusDevSupport.reset_spree_preferences_deprecated?

      example.run
    end
  end

  config.include ActiveJob::TestHelper

  config.after(:suite) do
    if Rails.respond_to?(:autoloaders) && Rails.autoloaders.zeitwerk_enabled?
      Rails.autoloaders.main.class.eager_load_all
    end
  rescue NameError => e
    class ZeitwerkNameError < NameError; end

    error_message =
      if e.message =~ /expected file .*? to define constant [\w:]+/
        e.message.sub(/expected file #{Regexp.escape(File.expand_path('../..', Rails.root))}./, "expected file ")
      else
        e.message
      end

    message = <<~WARN
      Zeitwerk raised the following error when trying to eager load your extension:

      #{error_message}

      This most likely means that your extension's file structure is not
      compatible with the Zeitwerk autoloader.
      Refer to https://github.com/solidusio/solidus_support#engine-extensions in
      order to update the file structure to match Zeitwerk's expectations.
    WARN

    raise ZeitwerkNameError, message
  end
end
