# frozen_string_literal: true

require "bundler/gem_tasks"

desc "Update the changelog, specify the version for the unreleased changes appending VERSION=1.2.3 to the command"
task :changelog do
  require_relative "lib/solidus_dev_support/version"

  future_release = ENV.fetch("VERSION") {
    warn "Using current version (#{SolidusDevSupport::VERSION}) for unreleased changes, use VERSION=1.2.3 to select a different one."
    SolidusDevSupport::VERSION
  }

  sh "bundle exec github_changelog_generator --project solidus_dev_support --user solidusio --future-release #{future_release}"
end

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

task default: :spec
