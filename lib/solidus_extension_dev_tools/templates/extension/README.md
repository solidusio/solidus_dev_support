<%= class_name %>
<%= "=" * class_name.size %>

Introduction goes here.

Installation
------------

Add <%= file_name %> to your Gemfile:

```ruby
gem '<%= file_name %>'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g <%= file_name %>:install
```

Testing
-------

First bundle your dependencies, then run `rake`. `rake` will default to building the dummy app if it does not exist, then it will run specs, and [Rubocop](https://github.com/bbatsov/rubocop) static code analysis. The dummy app can be regenerated by using `rake test_app`.

```shell
bundle
bundle exec rake
```

When testing your application's integration with this extension you may use its factories.
Simply add this require statement to your spec_helper:

```ruby
require '<%= file_name %>/factories'
```

Releasing
---------

Your new extension version can be released using `gem-release` like this:

```shell
bundle exec gem bump -v VERSION --tag --push --remote upstream && gem release
```

Copyright (c) <%= Time.now.year %> [name of extension creator], released under the New BSD License