# frozen_string_literal: true

require 'spree/testing_support/factories'
require 'factory_bot'

module SolidusDevSupport
  module TestingSupport
    module Factories
      def self.load_for(*engines)
        paths = engines.flat_map do |engine|
          engine.root.glob('lib/**/factories.rb')
        end

        if Spree::TestingSupport.respond_to? :load_all_factories
          FactoryBot.definition_file_paths.concat(
            paths.map { |path| path.sub(/.rb\z/, '').to_s }
          )
          FactoryBot.reload
        else
          FactoryBot.find_definitions

          paths.each { |path| require path }
        end
      end
    end
  end
end
