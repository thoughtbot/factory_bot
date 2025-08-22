# Custom Strategies

There are times where you may want to extend behavior of factory\_bot by adding
a custom build strategy.

Strategies define two methods: `association` and `result`. `association`
receives a `FactoryBot::FactoryRunner` instance, upon which you can call `run`,
overriding the strategy if you want. The second method, `result`, receives a
`FactoryBot::Evaluation` instance. It provides a way to trigger callbacks (with
`notify`), `object` or `hash` (to get the result instance or a hash based on
the attributes defined in the factory), and `create`, which executes the
`to_create` callback defined on the factory.

To understand how factory\_bot uses strategies internally, it's probably
easiest to view the source for each of the four default strategies.

Here's an example of composing a strategy using `FactoryBot::Strategy::Create`
to build a JSON representation of your model.

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

Finally, you can override factory\_bot's own strategies if you'd like by
registering a new object in place of the strategies.
