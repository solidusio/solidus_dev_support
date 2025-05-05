# frozen_string_literal: true

require "factory_bot"
require "spree/testing_support/factory_bot"

module SolidusDevSupport
  module TestingSupport
    module Factories
      def self.load_for(*engines)
        paths = engines.flat_map do |engine|
          engine.root.glob("lib/**/testing_support/factories{,.rb}")
        end.map { |path| path.sub(/.rb\z/, "").to_s }

        FactoryBot.definition_file_paths = [
          Spree::TestingSupport::FactoryBot.definition_file_paths,
          paths
        ].flatten

        FactoryBot.reload
      end
    end
  end
end
