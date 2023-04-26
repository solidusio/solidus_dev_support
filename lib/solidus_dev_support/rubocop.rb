# frozen_string_literal: true

module SolidusDevSupport
  module RuboCop
    CONFIG_PATH = "#{__dir__}/rubocop/config.yml".freeze

    def self.inject_defaults!
      config = ::RuboCop::ConfigLoader.load_file(CONFIG_PATH)
      puts "configuration from #{CONFIG_PATH}" if ::RuboCop::ConfigLoader.debug?
      config = ::RuboCop::ConfigLoader.merge_with_default(config, CONFIG_PATH, unset_nil: false)
      ::RuboCop::ConfigLoader.instance_variable_set(:@default_configuration, config)
    end
  end
end

SolidusDevSupport::RuboCop.inject_defaults!
