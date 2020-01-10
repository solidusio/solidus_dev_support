# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Enforced Rails version depending on the Solidus version in generated Gemfile
- Made Git ignore `spec/examples.txt` in generated extensions

### Fixed

- Fixed generated extensions using an old Rakefile

### Removed

- Removed RuboCop from the default Rake task

## [0.3.0] - 2019-01-10

### Added

- Adopted Ruby 2.4+ as the minimum Ruby version in generated extensions
- Added `bin/console`, `bin/rails` and `bin/setup` to generated extensions
- Added some Bundler gemspec defaults to generated extensions

### Changed

- Updated solidus_support to 0.4.0 for Zeitwerk and Rails 6 compatibility

### Removed

- Removed solidus_support as a dependency

## [0.2.0] - 2019-12-16

### Added

- Adopted [Apparition](https://github.com/twalpole/apparition) as the deafult JS driver for Capybara
- Fixed window size to 1920x1080px in feature specs
- Added [Stale](https://github.com/apps/stale) to automatically mark GitHub issues as stale

### Changed

- Disabled all `Metrics` cops except for `LineLength`
- Set `Layout/AlignArguments` cop to `with_fixed_indentation`
- Disabled `Layout/MultilineOperationIndentation` cop
- Renamed the project to SolidusDevSupport (was SolidusExtensionDevTools)

### Fixed

- Fixed Chrome not starting in headless mode

## [0.1.1] - 2019-11-11

### Fixed

- Fixed `rails_helper` not working due to `SolidusDevSupport` not being available

## [0.1.0] - 2019-11-11

Initial release.

[Unreleased]: https://github.com/solidusio-contrib/solidus_dev_support/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/solidusio-contrib/solidus_dev_support/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/solidusio-contrib/solidus_dev_support/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/solidusio-contrib/solidus_dev_support/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/solidusio-contrib/solidus_dev_support/releases/tag/v0.1.0
