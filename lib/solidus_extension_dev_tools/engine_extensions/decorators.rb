# frozen_string_literal: true

module SolidusExtensionDevTools
  module EngineExtensions
    module Decorators
      def self.included(engine)
        engine.class_eval do
          extend ClassMethods
          config.to_prepare(&method(:activate).to_proc)
        end
      end

      module ClassMethods
        def activate
          base_path = root.join('app/decorators')

          if Rails.respond_to?(:autoloaders)
            # Add decorators folder to the Rails autoloader. This
            # allows Zeitwerk to resolve decorators paths correctly,
            # when used.
            Dir.glob(base_path.join('*')) do |decorators_folder|
              Rails.autoloaders.main.push_dir(decorators_folder)
            end
          end

          # Load decorator files. This is needed since they are
          # never explicitely referenced in the application code
          # and won't be loaded by default. We need them to be
          # executed anyway to extend exisiting classes.
          Dir.glob(base_path.join('**/*.rb')) do |decorator_path|
            Rails.configuration.cache_classes ? require(decorator_path) : load(decorator_path)
          end
        end
      end
    end
  end
end
