# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added `--require spec_helper` to the generated `.rspec`

## [0.4.1] - 2020-01-15

### Fixed

- Fixed the generated RuboCop config inheriting from this gem's dev-only config
- Fixed the generated extension not requiring the `version` file
- Fixed the generator not properly marking `bin/` files as executable

## [0.4.0] - 2020-01-10

### Added

- Enforced Rails version depending on the Solidus version in generated Gemfile
- Made Git ignore `spec/examples.txt` in generated extensions
- Added the ability to run `solidus extension .` to update an extension

### Changed

- The `solidus` executable is now solely managed by Thor and is open to extension by other gems

### Fixed

- Fixed generated extensions using an old Rakefile
- Fixed some RuboCop offenses in the generated files
- Fixed the `bin/setup` script calling a non-existing Rake binary

### Removed

- Removed RuboCop from the default Rake task
- Removed the `-v` option from the `solidus` executable
- Removed the factory_bot gem from the Gemfile

## [0.3.0] - 2020-01-10

### Added

- Adopted Ruby 2.4+ as the minimum Ruby version in generated extensions
- Added `bin/console`, `bin/rails` and `bin/setup` to generated extensions
- Added some Bundler gemspec defaults to generated extensions
- Configured the default Rake task to run generate the test app before running RSpec

### Changed

- Updated solidus_support to 0.4.0 for Zeitwerk and Rails 6 compatibility
- Updated the `solidus` executable to only rely on Thor and be open to extension by other gems

### Removed

- Removed solidus_support as a dependency

### Fixed

- Fixed `extension:test_app` not going back to the root after execution

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

[Unreleased]: https://github.com/solidusio/solidus_dev_support/compare/v0.4.1...HEAD
[0.4.1]: https://github.com/solidusio/solidus_dev_support/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/solidusio/solidus_dev_support/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/solidusio/solidus_dev_support/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/solidusio/solidus_dev_support/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/solidusio/solidus_dev_support/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/solidusio/solidus_dev_support/releases/tag/v0.1.0
