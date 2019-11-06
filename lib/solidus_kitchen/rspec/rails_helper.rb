# frozen_string_literal: true

# A basic rails_helper to be included as the starting point for extensions
#
# Can be required from an extension's spec/rails_helper.rb
#
#     require 'solidus_kitchen/extension/rails_helper'
#

require 'solidus_kitchen/rspec/spec_helper'

require 'rspec/rails'
require 'database_cleaner'
require 'factory_bot_rails'
require 'ffaker'

require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/factories'
require 'spree/testing_support/url_helpers'
require 'spree/testing_support/preferences'
require 'spree/testing_support/controller_requests'
require 'solidus_kitchen/testing_support/preferences'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.include FactoryBot::Syntax::Methods

  # visit spree.admin_path
  # current_path.should eql(spree.products_path)
  config.include Spree::TestingSupport::UrlHelpers

  config.include Spree::TestingSupport::ControllerRequests, type: :controller

  config.include Spree::TestingSupport::Preferences
  config.include SolidusKitchen::TestingSupport::Preferences

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
      reset_spree_preferences unless SolidusKitchen.reset_spree_preferences_deprecated?

      example.run
    end
  end

  config.include ActiveJob::TestHelper
end
