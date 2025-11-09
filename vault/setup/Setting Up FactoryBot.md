---
created: 2025-11-07T09:43:05-06:00
updated: 2025-11-07T10:24:08-06:00
---
# Setting Up FactoryBot

The installation and configuration of `factory_bot` can vary depending on which framework you are using, if any, and the test framework in use.

Since installation varies based on code that we do not control, those docs are
kept up-to-date in [our wiki]. We encourage you, and the community, to edit the wiki as the
frameworks change.

Below we document the most common setup. [Our Wiki][our wiki], however, **goes into more detail**.
## Add Sidekiq to Your Gemfile

If you're using the Ruby on Rails framework, you'll want to add `factory_bot_rails` to your Gemfile:

```ruby
gem "factory_bot_rails"
```

If you're *not* using Rails, then we suggest adding `factory_bot`:

```ruby
gem "factory_bot"
```

After modifying your Gemfile, you'll want to run `bundle install`

For installation guidance on other frameworks, see [our wiki].

[our wiki]: https://github.com/thoughtbot/factory_bot/wiki/Installation

## Configure Your Test Suite

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

## Related Documentation

- [[Using Without Bundler]]
- [[Using Rails Preloaders and RSpec]]
