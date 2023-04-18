# skip_create, to_create, and initialize_with

The `skip_create`, `to_create`, and `initialize_with` methods control how
factory\_bot interacts with the [build strategies](build-strategies.html).

These methods can be called within a `factory` definition block, to scope their
effects to just that factory; or within `FactoryBot.define`, to affect global
change.

## initialize_with

The `initialize_with` method takes a block and returns an instance of the
factory's class. It has access to the `attributes` method, which is a hash of
all the fields and values for the object.

The default definition is:

```ruby
initialize_with { new }
```

## to_create

The `to_create` method lets you control the `FactoryBot.create` strategy. This
method takes a block which takes the object as constructed by
`initialize_with`, and the factory\_bot context. The context has additional
data from any [`transient`] blocks.

[`transient`]: transient.html

The default definition is:

```ruby
to_create { |obj, context| obj.save! }
```

The `skip_create` method is a shorthand for turning `to_create` into a no-op.
This allows you to use the `create` strategy as a synonym for `build`, except
you additionally get any `create` hooks.
