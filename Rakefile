# frozen_string_literal: true

require "bundler/gem_tasks"

require 'github_changelog_generator/task'
GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  config.user = 'solidusio'
  config.project = 'solidus_dev_support'
  config.exclude_labels = %w[infrastructure]
  config.issues = false
  config.base = "#{__dir__}/OLD_CHANGELOG.md"
  config.since_tag = 'v1.4.0'
end

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

task default: :spec
