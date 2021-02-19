# frozen_string_literal: true

require 'factory_bot'

Spree::Deprecation.silence do
  require 'spree/testing_support/factories'
  puts <<~MSG
    We are transitioning to a new way of loading factories for extensions.
    Be sure this extension does not load factories using require but uses
    the load_for() method in its spec_helper.rb, eg:

      SolidusDevSupport::TestingSupport::Factories.load_for(ExtensionName1::Engine, ExtensionName2::Engine)

    This will load Solidus Core factories right before the ones defined in
    lib/extension_name/testing_support/factories/*_factory.rb or
    lib/extension_name/testing_support/factories.rb

    This message will be removed when all extensions are updated.
  MSG
end

begin
  require 'spree/testing_support/factory_bot'
rescue LoadError
  # Do nothing, we are testing the extension against an old version of Solidus
end

module SolidusDevSupport
  module TestingSupport
    module Factories
      def self.load_for(*engines)
        paths = engines.flat_map do |engine|
          # Check if the extension has a lib/*/factories.rb. If it does, we emit a
          # deprecation warning and just use it.
          obsolete_factories_file = engine.root.glob('lib/*/factories.rb').first # 'lib/*/factories/*_factory.rb'
          if obsolete_factories_file.present?
            ActiveSupport::Deprecation.warn <<-WARN.squish, caller(4)
              SolidusDevSupport::TestingSupport::Factories.load_for() is automatically loading
              all factories present in #{obsolete_factories_file.dirname.to_s.gsub(engine.root.to_s, '')}/testing_support/factories/.
              Please move the content of #{obsolete_factories_file.to_s.gsub(engine.root.to_s, '')} to that directory.
            WARN

            [obsolete_factories_file]
          else
            # If there are both a lib/*/testing_support/factories.rb and a lib/*/testing_support/factories/,
            # we assume that the factories.rb file is only used to load all factories prensent in the directory.
            # That file can be removed from the extension, in fact, we ignore it and emit a message asking to
            # remove it.
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
            end
          end
        end.map { |path| path.sub(/.rb\z/, '').to_s }

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
