# frozen_string_literal: true

require 'thor'
require 'solidus_dev_support/extension'

module SolidusDevSupport
  class SolidusCommand < Thor
    namespace ''

    desc 'extension', 'Manage solidus extensions'
    subcommand 'extension', Extension

    desc 'e', 'Manage solidus extensions (shortcut for "extension")'
    subcommand 'e', Extension

    def self.exit_on_failure?
      true
    end
  end
end

