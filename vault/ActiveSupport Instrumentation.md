---
type: note
created: 2025-11-07T21:45:31-06:00
updated: 2025-11-08T14:42:27-06:00
tags: []
aliases:
up: "[[HOME]]"
---
# ActiveSupport Instrumentation

In order to track what objects are being constructed (and with what strategy), FactoryBot integrates `ActiveSupport::Notifications` to provide a way to subscribe to factories being compiled and run. 

## Subscribing to Factory Run Notifications

One example would be to track factories based on a threshold of execution time.

```ruby
ActiveSupport::Notifications.subscribe("factory_bot.run_factory") do |name, start, finish, id, payload|
  execution_time_in_seconds = finish - start

  if execution_time_in_seconds >= 0.5
    $stderr.puts "Slow factory: #{payload[:name]} using strategy #{payload[:strategy]}"
  end
end
```

## Tracking How Factories Are Used

Another example would be tracking all factories and how they're used throughout your test suite. If you're using RSpec, it's as simple as adding a `before(:suite)` and `after(:suite)`:

```ruby
factory_bot_results = {}
config.before(:suite) do
  ActiveSupport::Notifications.subscribe("factory_bot.run_factory") do |name, start, finish, id, payload|
    factory_name = payload[:name]
    strategy_name = payload[:strategy]
    factory_bot_results[factory_name] ||= {}
    factory_bot_results[factory_name][strategy_name] ||= 0
    factory_bot_results[factory_name][strategy_name] += 1
  end
end

config.after(:suite) do
  puts factory_bot_results
end
```

## Tracking Compiled Attributes and Traits

Another example could involve tracking the attributes and traits that factories are compiled with. If you're using RSpec, you could add `before(:suite)` and `after(:suite)` blocks that subscribe to `factory_bot.compile_factory` notifications:

```ruby
factory_bot_results = {}
config.before(:suite) do
  ActiveSupport::Notifications.subscribe("factory_bot.compile_factory") do |name, start, finish, id, payload|
    factory_name = payload[:name]
    factory_class = payload[:class]
    attributes = payload[:attributes]
    traits = payload[:traits]
    factory_bot_results[factory_class] ||= {}
    factory_bot_results[factory_class][factory_name] = {
      attributes: attributes.map(&:name)
      traits: traits.map(&:name)
    }
  end
end

config.after(:suite) do
  puts factory_bot_results
end
```
