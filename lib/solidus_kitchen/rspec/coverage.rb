# frozen_string_literal: true

# A SimpleCov and Codecov configuration to track code coverage in your extension
#
# Include it AT THE TOP of your spec/spec_helper.rb:
#
#     require 'solidus_support/extension/coverage'
#
# Note that things may not work properly if you don't include this at the very top!
#

require 'simplecov'
SimpleCov.start 'rails'

if ENV['CI']
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end
