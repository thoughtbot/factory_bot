# Hooks

Within a `factory` definition block and the `FactoryBot.define` block, you have
access to the `after`, `before`, and `callback` methods. This allow you to hook
into parts of the [build strategies].

[build strategies]: build-strategies.html

Within a `factory` definition block, these callbacks are scoped to just that
factory. Within a `FactoryBot.define` block, they are global to all factories.

## `callback`

The `callback` method allows you to hook into any factory\_bot callback by
name. The pre-defined names, as seen in the [build strategies] reference, are
`after_build`, `before_create`, `after_create`, and `after_stub`.

This method takes a splat of names, and a block. It invokes the block any time
one of the names is activated. The block can be anything that responds to
`#to_proc`.

This block takes two arguments: the instance of the factory, and the
factory\_bot context. The context holds [transient](transient.html)
attributes.

The same callback name can be hooked into multiple times. Every block is run,
in the order it was defined. Callbacks are inherited from their parents; the
parents' callbacks are run first.

## `after` and `before` methods

The `after` and `before` methods add some nice syntax to `callback`:

```ruby
after(:create) do |user, context|
  user.post_first_article(context.article)
end

callback(:after_create) do |user, context|
  user.post_first_article(context.article)
end
```
