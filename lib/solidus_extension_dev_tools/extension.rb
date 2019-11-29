# frozen_string_literal: true

require 'thor'
require 'thor/group'

module SolidusExtensionDevTools
  class Extension < Thor::Group
    include Thor::Actions

    desc 'builds a solidus extension'
    argument :file_name, type: :string, desc: 'rails app_path', default: '.'
    class_option :ci, type: :string, desc: 'which ci platform to use (circleci, travis)', default: 'circleci'

    source_root File.expand_path('templates/extension', __dir__)

    def generate
      use_prefix 'solidus_'

      empty_directory file_name

      directory 'app', "#{file_name}/app"
      directory 'lib', "#{file_name}/lib"
      directory 'bin', "#{file_name}/bin"

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

      case options[:ci]
      when "travis"
        template 'travis.yml', "#{file_name}/.travis.yml"
      when "circleci"
        directory '.circleci', "#{file_name}/.circleci"
      end
    end

    no_tasks do
      def class_name
        Thor::Util.camel_case file_name
      end

      def use_prefix(prefix)
        @file_name = prefix + Thor::Util.snake_case(file_name) unless file_name =~ /^#{prefix}/
      end
    end
  end
end
