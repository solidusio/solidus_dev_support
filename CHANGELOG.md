# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Adopted [Apparition](https://github.com/twalpole/apparition) as the deafult JS driver for Capybara
- Fix window size to 1920x1080px in feature specs
- Add the [Github configuration](https://github.com/apps/stale) to automatically mark issues as stale
- Add the [Github configuration](https://github.com/apps/stale) for all the new extension generated using this gem

### Changed

- Disabled all `Metrics` cops except for `LineLength`
- Set `Layout/AlignArguments` cop to `with_fixed_indentation`
- Disabled `Layout/MultilineOperationIndentation` cop

### Fixed

- Fix Chrome not starting in headless mode

## [0.1.1] - 2019-11-11

### Fixed

- Fixed `rails_helper` not working due to `SolidusExtensionDevTools` not being available

## [0.1.0] - 2019-11-11

Initial release.

[Unreleased]: https://github.com/solidusio-contrib/solidus_extension_dev_tools/compare/v0.1.1...HEAD
[0.1.1]: https://github.com/solidusio-contrib/solidus_extension_dev_tools/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/solidusio-contrib/solidus_extension_dev_tools/releases/tag/v0.1.0
