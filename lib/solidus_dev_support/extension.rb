# frozen_string_literal: true

require 'thor'
require 'thor/group'
require 'pathname'

module SolidusDevSupport
  class Extension < Thor::Group
    include Thor::Actions

    desc 'builds a solidus extension'
    argument :file_name, type: :string, desc: 'rails app_path', default: '.'

    source_root File.expand_path('templates/extension', __dir__)

    def generate
      use_prefix 'solidus_'

      empty_directory file_name

      directory 'app', "#{file_name}/app"
      directory 'lib', "#{file_name}/lib"
      directory 'bin', "#{file_name}/bin"
      directory '.circleci', "#{file_name}/.circleci"
      directory '.github', "#{file_name}/.github"

      Dir["#{file_name}/bin/*"].each do |executable|
        make_executable executable
      end

      template 'extension.gemspec.erb', "#{file_name}/#{file_name}.gemspec"
      template 'Gemfile', "#{file_name}/Gemfile"
      template 'gitignore', "#{file_name}/.gitignore"
      template 'gem_release.yml.tt', "#{file_name}/.gem_release.yml"
      template 'LICENSE', "#{file_name}/LICENSE"
      template 'Rakefile', "#{file_name}/Rakefile"
      template 'README.md', "#{file_name}/README.md"
      template 'config/routes.rb', "#{file_name}/config/routes.rb"
      template 'config/locales/en.yml', "#{file_name}/config/locales/en.yml"
      template 'rspec', "#{file_name}/.rspec"
      template 'spec/spec_helper.rb.tt', "#{file_name}/spec/spec_helper.rb"
      template 'rubocop.yml', "#{file_name}/.rubocop.yml"
    end

    no_tasks do
      def class_name
        Thor::Util.camel_case file_name
      end

      def use_prefix(prefix)
        @file_name = prefix + Thor::Util.snake_case(file_name) unless file_name =~ /^#{prefix}/
      end

      def make_executable(path)
        path = Pathname(path)
        executable = (path.stat.mode | 0o111)
        path.chmod(executable)
      end
    end
  end
end
