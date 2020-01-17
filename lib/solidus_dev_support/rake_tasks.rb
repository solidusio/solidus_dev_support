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
      @sandbox_path = @root.join(ENV['SANDBOX_PATH'] || 'tmp/sample_store')
      @gemspec = Bundler.load_gemspec(@root.glob("{,*}.gemspec").first)
    end

    attr_reader :test_app_path, :sandbox_path, :root, :gemspec

    def install
      install_test_app_task
      install_sandbox_task
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

    def install_sandbox_task
      require 'rake/clean'
      ::CLOBBER.include sandbox_path

      ENV['SANDBOX_PATH'] = sandbox_path.to_s
      ENV['LIB_NAME'] = gemspec.name
      require 'solidus_dev_support/sandbox_tasks'

      namespace :extension do
        directory ENV['SANDBOX_PATH'] do
          Rake::Task['extension:sandbox']

          # We need to go back to the gem root since extension:sandbox changes
          # the working directory to be the development app.
          cd root
        end
      end
    end

    def install_sandbox_helper_tasks
      require 'rake/clean'
      ::CLOBBER.include sandbox_path

      ENV['SANDBOX_PATH'] = sandbox_path.to_s
      ENV['LIB_NAME'] = gemspec.name
      require 'solidus_dev_support/dev_support'

      namespace :extension do
        directory ENV['SANDBOX_PATH'] do
          Rake::Task['extension:sandbox:server']

          # We need to go back to the gem root since extension:sandbox changes
          # the working directory to be the development app.
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
