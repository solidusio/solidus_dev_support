# solidus_extension_dev_tools

This is a collection of tools for developing Solidus extensions.

## Installation

Add this gem as a development dependency of your extension:

```ruby
spec.add_development_dependency 'solidus_extension_dev_tools'
```

And then execute:

```console
$ bundle
```

## Usage

### RSpec helpers

This gem provides some useful helpers for RSpec to setup an extension's test environment easily.

Add this to your extension's `spec/spec_helper.rb`:

```ruby
require 'solidus_extension_dev_tools/rspec/feature_helper'
```

This helper loads configuration needed to run extension feature specs correctly, setting up Capybara
and configuring a Rails test application to precompile assets before the first feature spec.

`feature_helper` builds on top of `rails_helper`, which you can also use a standalone helper if you
want:

```ruby
require 'solidus_extension_dev_tools/rspec/rails_helper'
```

This will include the Rails and Solidus-related RSpec configuration, such as authorization helpers,
Solidus factories, URL helpers, and other helpers to easily work with Solidus.

`rails_helper`, in turn, builds on top of `spec_helper`, which is responsible for setting up a
basic RSpec environment:

```ruby
require 'solidus_extension_dev_tools/rspec/spec_helper'
```

### Code coverage

The gem also includes a SimpleCov configuration that will send your test coverage information
directly to Codecov.io. Simply add this at the top of your `spec/spec_helper.rb`:

```ruby
require 'solidus_extension_dev_tools/rspec/coverage'
```

**Note: Make sure to add this at the VERY TOP of your spec_helper, otherwise you'll get skewed
coverage reports!**

If your extension is in a public repo and being tested on Travis or CircleCI, there's nothing else
you need to do! If your setup is more complex, look at the
[SimpleCov](https://github.com/colszowka/simplecov)
and [codecov-ruby](https://github.com/codecov/codecov-ruby) docs.

### RuboCop configuration

solidus_extension_dev_tools includes a default [RuboCop](https://github.com/rubocop-hq/rubocop)
configuration for Solidus extensions. Currently, this is based on 
[Relaxed Ruby Style](https://relaxed.ruby.style) with a few customizations, but in the future we
plan to provide custom cops to ensure your extension follows established Solidus best practices.

We strongly recommend including the RuboCop configuration in your extension. All you have to do is
add this to your `.rubocop.yml`:

```yaml
require:
  - solidus_extension_dev_tools/rubocop
``` 

You can now run RuboCop with:

```console
$ bundle exec rubocop
```

### Changelog generator

Generating a changelog for your extension is possible by running this command:

```console
$ CHANGELOG_GITHUB_TOKEN="«your-40-digit-github-token»" bundle exec github_changelog_generator github_username/github_project
```

This generates a `CHANGELOG.md`, with pretty Markdown formatting.

For further instructions please read the [GitHub Changelog Generator documentation](https://github.com/github-changelog-generator/github-changelog-generator#usage).

### Release management

By installing solidus_extension_dev_tools, you also get
[`gem release`](https://github.com/svenfuchs/gem-release), which you can use to automatically manage
releases for your gem.

For instance, you can run the following to release a new minor version:

```console
gem bump --version minor --tag --release
```

The above command will:

* bump the gem version to the next minor;
* commit the change and push it to `upstream/master`;
* create a Git tag;
* push the tag to the `upstream` remote;
* release the new version on RubyGems.

You can refer to 
[`gem release`'s documentation](https://github.com/svenfuchs/gem-release/blob/master/README.md) for
further configuration and usage instructions.

### Rake tasks

Put this in your `Rakefile`:

```rb
require 'solidus_extension_dev_tools/rake_tasks'
SolidusExtensionDevTools::RakeTasks.install

task default: 'extension:specs'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run 
the tests. You can also run `bin/console` for an interactive prompt that will allow you to 
experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new 
version, update the version number in `version.rb`, and then run `bundle exec rake release`, which 
will create a git tag for the version, push git commits and tags, and push the `.gem` file to 
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/solidusio/solidus_extension_dev_tools.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
