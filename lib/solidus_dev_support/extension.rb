# frozen_string_literal: true

require 'thor'
require 'pathname'

module SolidusDevSupport
  class Extension < Thor
    include Thor::Actions
    PREFIX = 'solidus_'

    default_command :generate

    desc 'generate PATH', 'Generates a new Solidus extension'
    def generate(raw_path = '.')
      self.path = raw_path

      empty_directory path

      directory 'app', "#{path}/app"
      directory 'lib', "#{path}/lib"
      directory 'bin', "#{path}/bin"
      directory '.circleci', "#{path}/.circleci"
      directory '.github', "#{path}/.github"

      %w[
        bin/console
        bin/rails
        bin/rake
        bin/setup
      ].each do |bin|
        template bin, "#{path}/#{bin}"
        make_executable "#{path}/#{bin}"
      end

      template 'extension.gemspec.erb', "#{path}/#{file_name}.gemspec"
      template 'Gemfile', "#{path}/Gemfile"
      template 'gitignore', "#{path}/.gitignore"
      template 'gem_release.yml.tt', "#{path}/.gem_release.yml"
      template 'LICENSE', "#{path}/LICENSE"
      template 'Rakefile', "#{path}/Rakefile"
      template 'README.md', "#{path}/README.md"
      template 'config/routes.rb', "#{path}/config/routes.rb"
      template 'config/locales/en.yml', "#{path}/config/locales/en.yml"
      template 'rspec', "#{path}/.rspec"
      template 'spec/spec_helper.rb.tt', "#{path}/spec/spec_helper.rb"
      template 'rubocop.yml', "#{path}/.rubocop.yml"
    end

    no_tasks do
      def path=(path)
        path = File.expand_path(path)

        @file_name = Thor::Util.snake_case(File.basename(path))
        @file_name = PREFIX + @file_name unless @file_name.start_with?(PREFIX)

        @class_name = Thor::Util.camel_case @file_name

        @root = File.dirname(path)
        @path = File.join(@root, @file_name)
      end

      def make_executable(path)
        path = Pathname(path)
        executable = (path.stat.mode | 0o111)
        path.chmod(executable)
      end

      attr_reader :root, :path, :file_name, :class_name
    end

    def self.source_root
      "#{__dir__}/templates/extension"
    end
  end
end
