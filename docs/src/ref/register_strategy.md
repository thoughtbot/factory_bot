# FactoryBot.register_strategy

The `FactoryBot.register_strategy` method is how to add a [build
strategy](build-strategies.html).

It takes two mandatory arguments: name and class. The name is a Symbol, and
registering it exposes a method under `FactoryBot::Syntax::Methods`.

The class must define the methods `association` and `result`.

The `association` method takes an instance of `FactoryRunner`. You can `#run`
this runner, passing a strategy name (it defaults to the current one) and an
optional block. The block is called after the association is built, and is
passed the object that was built.

The `result` method takes the object that was built for this factory (using
`initalize_with`), and returns the result of this factory for this build
strategy.
