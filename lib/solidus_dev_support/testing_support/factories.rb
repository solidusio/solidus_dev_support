# frozen_string_literal: true

begin
  require 'spree/testing_support/factory_bot'
rescue LoadError
  require 'factory_bot'
  require 'spree/testing_support/factories'
end

module SolidusDevSupport
  module TestingSupport
    module Factories
      def self.load_for(*engines)
        paths = engines.flat_map do |engine|
          factories_file_or_folder = engine.root.glob('lib/*/testing_support/factories{,.rb}')
          if factories_file_or_folder.size == 2
            folder, file = factories_file_or_folder.partition(&:directory?).map(&:first).map { |path| path.to_s.gsub(engine.root.to_s, '') }
            ActiveSupport::Deprecation.warn <<-WARN.squish, caller(4)
              SolidusDevSupport::TestingSupport::Factories.load_for() is automatically loading
              all factories present into #{folder}. You should now safely remove #{file} if it
              is only used to load ./factories content.
            WARN

            engine.root.glob('lib/*/testing_support/factories/**/*_factory.rb')
          else
            factories_file_or_folder
          end.map { |path| path.sub(/.rb\z/, '').to_s }
        end

        if using_factory_bot_definition_file_paths?
          FactoryBot.definition_file_paths = [
            Spree::TestingSupport::FactoryBot.definition_file_paths,
            paths,
          ].flatten

          FactoryBot.reload
        else
          FactoryBot.find_definitions

          paths.each { |path| require path }
        end
      end

      def self.using_factory_bot_definition_file_paths?
        defined?(Spree::TestingSupport::FactoryBot) &&
          Spree::TestingSupport::FactoryBot.respond_to?(:definition_file_paths)
      end
    end
  end
end
