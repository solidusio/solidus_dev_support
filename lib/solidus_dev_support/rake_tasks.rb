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
      install_dev_app_task
      install_rspec_task
      install_changelog_task
    end

    def install_test_app_task
      require 'rake/clean'
      require 'spree/testing_support/extension_rake'

      ENV['DUMMY_PATH'] = test_app_path.to_s
      ENV['LIB_NAME'] = gemspec.name

      ::CLOBBER.include test_app_path

      namespace :extension do
        # We need to go back to the gem root since the upstream
        # extension:test_app changes the working directory to be the dummy app.
        task :test_app do
          Rake::Task['extension:test_app'].invoke
          cd root
        end

        directory ENV['DUMMY_PATH'] do
          Rake::Task['extension:test_app'].invoke
        end
      end
    end

    def install_dev_app_task
      desc "Creates a sandbox application for simulating the Extension code in a deployed Rails app"
      task :sandbox do
        warn "DEPRECATED TASK: This task is here just for parity with solidus, please use bin/sandbox directly."
        exec("bin/sandbox", gemspec.name)
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

    def install_changelog_task
      require 'github_changelog_generator/task'

      source_code_uri = URI.parse(gemspec.metadata['source_code_uri'] || gemspec.homepage)
      user, project = source_code_uri.path.split("/", 3)[1..2]

      GitHubChangelogGenerator::RakeTask.new(:changelog) do |config|
        config.user = user || 'solidusio-contrib'
        config.project = project || gemspec.name
        config.future_release = "v#{gemspec.version}"
      end
    end
  end
end
