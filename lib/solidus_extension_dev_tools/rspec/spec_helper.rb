# frozen_string_literal: true

# A basic spec_helper to be included as the starting point for extensions
#
# Can be required from an extension's spec/spec_helper.rb
#
#     require 'solidus_extension_dev_tools/rspec/spec_helper'
#

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.mock_with :rspec
  config.color = true

  config.fail_fast = ENV['FAIL_FAST'] || false
  config.order = 'random'

  config.raise_errors_for_deprecations!

  config.example_status_persistence_file_path = "./spec/examples.txt"

  Kernel.srand config.seed
end
