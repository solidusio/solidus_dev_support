# frozen_string_literal: true

# A SimpleCov and Codecov configuration to track code coverage in your extension
#
# Include it AT THE TOP of your spec/spec_helper.rb:
#
#     require 'solidus_dev_support/rspec/coverage'
#
# Note that things may not work properly if you don't include this at the very top!
#

require "simplecov"
SimpleCov.start("rails") do
  add_filter %r{^/lib/generators/.*/install/install_generator.rb}
  add_filter %r{^/lib/.*/factories.rb}
  add_filter %r{^/lib/.*/version.rb}
end

if ENV["CODECOV_TOKEN"]
  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
  warn <<~WARN
    DEPRECATION WARNING: The Codecov ruby uploader is deprecated.
    Please use the Codecov CLI uploader to upload code coverage reports.
    See https://docs.codecov.com/docs/deprecated-uploader-migration-guide#ruby-uploader for more information on upgrading.
  WARN
elsif ENV["CODECOV_COVERAGE_PATH"]
  require "simplecov-cobertura"
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
else
  warn "Provide a CODECOV_COVERAGE_PATH environment variable to enable Codecov uploads"
end
