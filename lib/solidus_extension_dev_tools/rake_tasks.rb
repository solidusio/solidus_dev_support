# frozen_string_literal: true

require 'rake'
require 'pathname'

module SolidusExtensionDevTools
  class RakeTasks
    include Rake::DSL

    def self.install(*args)
      new(*args).tap(&:install)
    end

    def initialize(root: Dir.pwd)
      @root = Pathname(root)
    end

    attr_reader :test_app_path, :root, :gemspec

    def install
    end
  end
end
