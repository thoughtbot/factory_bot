# Setup

Installation varies based on the framework you are using, if any, and
optionally the test framework.

Since installation varies based on code that we do not control, those docs are
kept up-to-date in [our wiki]. We encourage you to edit the wiki as the
frameworks change.

Below we document the most common setup. However, **we go into more detail in
[our wiki]**.

[our wiki]: https://github.com/thoughtbot/factory_bot/wiki/Installation

## Update Your Gemfile

If you're using Rails:

```ruby
gem "factory_bot_rails"
```

If you're *not* using Rails:

```ruby
gem "factory_bot"
```

For more, see [our wiki].

## Configure your test suite

### RSpec

```ruby
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
```

### Test::Unit

```ruby
class Test::Unit::TestCase
  include FactoryBot::Syntax::Methods
end
```

For more, see [our wiki].
