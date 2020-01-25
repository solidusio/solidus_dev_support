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

      Dir["#{path}/bin/*"].each do |bin|
        make_executable bin
      end

      template 'extension.gemspec', "#{path}/#{file_name}.gemspec"
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

        @gemspec = existing_gemspec || default_gemspec
      end

      def gemspec_path
        @gemspec_path ||= File.join(path, "#{file_name}.gemspec")
      end

      def default_gemspec
        @default_gemspec ||= Gem::Specification.new(@file_name, '0.0.1') do |gem|
          gem.author = git('config user.name', 'TODO: Write your name')
          gem.description = 'TODO: Write a longer description or delete this line.'
          gem.email = git('config user.email', 'TODO: Write your email address')
          gem.homepage = default_homepage
          gem.license = 'BSD-3-Clause'
          gem.metadata['changelog_uri'] = default_homepage + '/releases'
          gem.summary = 'TODO: Write a short summary, because RubyGems requires one.'
        end
      end

      def existing_gemspec
        return unless File.exist?(gemspec_path)

        @existing_gemspec ||= Gem::Specification.load(gemspec_path).tap do |spec|
          spec.author ||= default_gemspec.author
          spec.email ||= default_gemspec.email
          spec.homepage ||= default_gemspec.homepage
          spec.license ||= default_gemspec.license
          spec.metadata['changelog_uri'] ||= default_gemspec.metadata[:changelog_uri]
          spec.summary ||= default_gemspec.summary
        end
      end

      def default_homepage
        @default_homepage ||= git(
          'remote get-url origin',
          "git@github.com:#{github_user}/#{file_name}.git"
        ).sub(
          %r{^.*github\.com.([^/]+)/([^/\.]+).*$},
          'https://github.com/\1/\2'
        )
      end

      def github_user
        @github_user ||= git('config github.user', '[USERNAME]')
      end

      def git(command, default)
        result = `git #{command} 2> /dev/null`.strip
        result.empty? ? default : result
      end

      def make_executable(path)
        path = Pathname(path)
        executable = (path.stat.mode | 0o111)
        path.chmod(executable)
      end

      attr_reader :root, :path, :file_name, :class_name, :gemspec
    end

    def self.source_root
      "#{__dir__}/templates/extension"
    end
  end
end
