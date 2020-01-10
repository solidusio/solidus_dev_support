# frozen_string_literal: true

require 'rake'
require 'pathname'

module SolidusDevSupport
  class RakeTasks
    include Rake::DSL

    def self.install(*args)
      new(*args).tap(&:install)
    end

    def initialize(root: Dir.pwd)
      @root = Pathname(root)
      @test_app_path = @root.join(ENV['DUMMY_PATH'] || 'spec/dummy')
      @gemspec = Bundler.load_gemspec(@root.glob("{,*}.gemspec").first)
    end

    attr_reader :test_app_path, :root, :gemspec

    def install
      install_test_app_task
      install_rspec_task
    end

    def install_test_app_task
      require 'rake/clean'
      require 'spree/testing_support/extension_rake'

      ENV['DUMMY_PATH'] = test_app_path.to_s
      ENV['LIB_NAME'] = gemspec.name

      ::CLOBBER.include test_app_path

      namespace :extension do
        task :test_app do
          Rake::Task['extension:test_app'].invoke
          cd root
        end
      end
    end

    def install_rspec_task
      require 'rspec/core/rake_task'

      namespace :extension do
        ::RSpec::Core::RakeTask.new(:specs, [] => FileList[ENV['DUMMY_PATH']]) do |t|
          # Ref: https://circleci.com/docs/2.0/configuration-reference#store_test_results
          # Ref: https://github.com/solidusio/circleci-orbs-extensions#test-results-rspec
          if ENV['TEST_RESULTS_PATH']
            t.rspec_opts =
              "--format progress " \
              "--format RspecJunitFormatter --out #{ENV['TEST_RESULTS_PATH']}"
          end
        end
      end
    end
  end
end
