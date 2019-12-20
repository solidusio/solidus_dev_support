# frozen_string_literal: true

require "rails/generators/rails/app/app_generator"
require 'active_support/core_ext/hash'
require 'spree/core/version'

module Spree
  # @private
  class DevGenerator < Rails::Generators::Base
    desc "Creates blank Rails application, installs Solidus and all sample data"

    class_option :lib_name, default: ''
    class_option :database, default: ''

    def self.source_paths
      paths = superclass.source_paths
      paths << File.expand_path('templates', __dir__)
      paths.flatten
    end

    def clean_up
      remove_directory_if_exists(dev_path)
    end

    PASSTHROUGH_OPTIONS = [
      :skip_active_record, :skip_javascript, :database, :javascript, :quiet, :pretend, :force, :skip
    ]

    def generate_dev_app
      # calling slice on a Thor::CoreExtensions::HashWithIndifferentAccess
      # object has been known to return nil
      opts = {}.merge(options).slice(*PASSTHROUGH_OPTIONS)
      opts[:database] = 'sqlite3' if opts[:database].blank?
      opts[:force] = true
      opts[:skip_bundle] = true
      opts[:skip_gemfile] = true
      opts[:skip_git] = true
      opts[:skip_keeps] = true
      opts[:skip_listen] = true
      opts[:skip_puma] = true
      opts[:skip_rc] = true
      opts[:skip_spring] = true
      opts[:skip_test] = true
      opts[:skip_yarn] = true

      puts "Generating dev Rails application..."
      invoke Rails::Generators::AppGenerator,
        [File.expand_path(dev_path, destination_root)], opts
    end

    def test_dev_config
      @lib_name = options[:lib_name]
      @database = options[:database]

      template "rails/database.yml", "#{dev_path}/config/database.yml", force: true
      template "rails/boot.rb", "#{dev_path}/config/boot.rb", force: true
      template "rails/application.rb.tt", "#{dev_path}/config/application.rb", force: true
      template "rails/routes.rb", "#{dev_path}/config/routes.rb", force: true
      template "rails/test.rb.tt", "#{dev_path}/config/environments/test.rb", force: true
      template "rails/script/rails", "#{dev_path}/spec/dev/script/rails", force: true
    end

    def test_dev_inject_extension_requirements
      if DevGeneratorHelper.inject_extension_requirements
        inside dev_path do
          inject_require_for('spree_frontend')
          inject_require_for('spree_backend')
          inject_require_for('spree_api')
        end
      end
    end

    def test_dev_clean
      inside dev_path do
        remove_file ".gitignore"
        remove_file "doc"
        remove_file "Gemfile"
        remove_file "lib/tasks"
        remove_file "app/assets/images/rails.png"
        remove_file "app/assets/javascripts/application.js"
        remove_file "public/index.html"
        remove_file "public/robots.txt"
        remove_file "README"
        remove_file "test"
        remove_file "vendor"
        remove_file "spec"
      end
    end

    attr_reader :lib_name
    attr_reader :database

    protected

    def inject_require_for(requirement)
      inject_into_file 'config/application.rb', %[
begin
  require '#{requirement}'
rescue LoadError
  # #{requirement} is not available.
end
      ], before: /require '#{@lib_name}'/, verbose: true
    end

    def dev_path
      ENV['DEV_APP_PATH'] || 'tmp/sample_store'
    end

    def module_name
      'SampleStore'
    end

    def application_definition
      @application_definition ||= begin
        dev_application_path = File.expand_path("#{dev_path}/config/application.rb", destination_root)
        unless options[:pretend] || !File.exist?(dev_application_path)
          contents = File.read(dev_application_path)
          contents[(contents.index("module #{module_name}"))..-1]
        end
      end
    end
    alias :store_application_definition! :application_definition

    def camelized
      @camelized ||= name.gsub(/\W/, '_').squeeze('_').camelize
    end

    def remove_directory_if_exists(path)
      remove_dir(path) if File.directory?(path)
    end

    def gemfile_path
      core_gems = ["spree/core", "spree/api", "spree/backend", "spree/frontend"]

      if core_gems.include?(lib_name)
        '../../../../../Gemfile'
      else
        '../../../../Gemfile'
      end
    end
  end

  # @private
  module DevGeneratorHelper
    mattr_accessor :inject_extension_requirements
    self.inject_extension_requirements = false
  end
end
