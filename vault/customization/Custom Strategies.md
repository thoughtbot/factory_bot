---
type: note
created: 2025-08-29T16:16:26-05:00
updated: 2025-11-08T21:25:26-06:00
tags:
  - strategies
aliases:
  - Custom Strategies
  - Custom Strategy
up: "[[§ customization]]"
---
# Custom Strategies

There are times where you may want to extend behavior of factory\_bot by adding a custom construction strategy. This is a guide for how to accomplish this.

## Introduction

Strategies define two methods: `association` and `result`. `association` receives a `FactoryBot::FactoryRunner` instance, upon which you can call `run`, overriding the strategy if you want. The second method, `result`, receives a `FactoryBot::Evaluation` instance. It provides a way to trigger callbacks (with `notify`), `object` or `hash` (to get the result instance or a hash based on the attributes defined in the factory), and `create`, which executes the `to_create` callback defined on the factory.

To understand how factory\_bot uses strategies internally, it's probably easiest to view the source for each of the four default strategies.

## The `FactoryBot.register_strategy` Method

The `FactoryBot.register_strategy` method is used to add a custom [[§ strategies|Strategy]]

This method takes two mandatory arguments: name and class. 

- The name is a Symbol, and registering it automatically register syntax methods in the format of `{name}`, `{name}_pair`, and `{name}_list` (These methods are exposed via `FactoryBot::Syntax::Methods`).
- The class must define the methods `association` and `result`.

## The Custom Strategy Class

The class is required to define two methods:

- `association` 
- `result`

The `association` method takes an instance of `FactoryRunner`. You can `#run` this runner, passing a strategy name (it defaults to the current one) and an optional block. The block is called after the association is built, and is passed the object that was built.

The `result` method takes the object that was built for this factory (using `initalize_with`), and returns the result of this factory for this construction strategy.

## Example: JSON Strategy

Here's an example of composing a strategy using `FactoryBot::Strategy::Create` to build a JSON representation of your model.

```ruby
class JsonStrategy
  def initialize
    @strategy = FactoryBot.strategy_by_name(:create).new
  end

  delegate :association, to: :@strategy

  def result(evaluation)
    @strategy.result(evaluation).to_json
  end

  def to_sym
    :json
  end
end
```

For factory\_bot to recognize the new strategy, you can register it:

```ruby
FactoryBot.register_strategy(:json, JsonStrategy)
```

This allows you to call

```ruby
FactoryBot.json(:user)
```

## Overriding Built-In Strategies

Finally, you can override factory\_bot's own strategies if you'd like by registering a new object in place of the strategies.
