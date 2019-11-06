# solidus_kitchen

This is a collection of tools for developing Solidus extensions.

## Installation

Add this gem as a development dependency of your extension:

```ruby
spec.add_development_dependency 'solidus_kitchen'
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
require 'solidus_kitchen/rspec/feature_helper'
```

This helper loads configuration needed to run extension feature specs correctly, setting up Capybara
and configuring a Rails test application to precompile assets before the first feature spec.

`feature_helper` builds on top of `rails_helper`, which you can also use a standalone helper if you
want:

```ruby
require 'solidus_kitchen/rspec/rails_helper'
```

This will include the Rails and Solidus-related RSpec configuration, such as authorization helpers,
Solidus factories, URL helpers, and other helpers to easily work with Solidus.

`rails_helper`, in turn, builds on top of `spec_helper`, which is responsible for setting up a
basic RSpec environment:

```ruby
require 'solidus_kitchen/rspec/spec_helper'
```

### Code coverage

The gem also includes a SimpleCov configuration that will send your test coverage information
directly to Codecov.io. Simply add this at the top of your `spec/spec_helper.rb`:

```ruby
require 'solidus_kitchen/rspec/coverage'
```

**Note: Make sure to add this at the VERY TOP of your spec_helper, otherwise you'll get skewed
coverage reports!**

If your extension is in a public repo and being tested on Travis or CircleCI, there's nothing else
you need to do! If your setup is more complex, look at the
[SimpleCov](https://github.com/colszowka/simplecov)
and [codecov-ruby](https://github.com/codecov/codecov-ruby) docs.

### RuboCop configuration

solidus_kitchen includes a default [RuboCop](https://github.com/rubocop-hq/rubocop) configuration
for Solidus extensions. Currently, this is based on [Relaxed Ruby Style](https://relaxed.ruby.style)
with a few customizations, but in the future we plan to provide custom cops to ensure your
extension follows established Solidus best practices.

We strongly recommend including the RuboCop configuration in your extension. All you have to do is
add this to your `.rubocop.yml`:

```yaml
require:
  - solidus_kitchen/rubocop

inherit_gem:
  solidus_kitchen: .rubocop.extension.yml

AllCops:
  Exclude:
    - spec/dummy/**/*
``` 

You can now run RuboCop with:

```console
$ bundle exec rubocop
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

Bug reports and pull requests are welcome on GitHub at https://github.com/solidusio/solidus_kitchen.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
