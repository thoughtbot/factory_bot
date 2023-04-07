# RSpec

If you're using Rails, add the following configuration to
`spec/support/factory_bot.rb` and be sure to require that file in
`rails_helper.rb`:

```ruby
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
```

If you're *not* using Rails:

```ruby
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
```
