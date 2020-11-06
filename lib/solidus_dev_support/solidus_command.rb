# frozen_string_literal: true

require 'thor'
require 'solidus_dev_support/extension'
require 'spree/core/version'

module SolidusDevSupport
  class SolidusCommand < Thor
    namespace ''

    desc 'extension', 'Manage solidus extensions'
    subcommand 'extension', Extension

    desc 'e', 'Manage solidus extensions (shortcut for "extension")'
    subcommand 'e', Extension

    desc 'version', 'Displays solidus_dev_support version'
    def version
      puts "Solidus version #{Spree.solidus_gem_version}"
      puts "Solidus Dev Support version #{SolidusDevSupport::VERSION}"
    end
    map ['-v', '--version'] => :version

    def self.exit_on_failure?
      true
    end
  end
end
