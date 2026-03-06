---
type: note
created: 2026-03-06T16:14:49-06:00
updated: 2026-03-06T16:15:04-06:00
tags: []
aliases: []
---
# Adding FactoryBot to Your Test Suite

## Configuring Your Test Suite

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

[our wiki]: https://github.com/thoughtbot/factory_bot/wiki/Installation
