---
type: note
created: 2025-11-08T20:36:06-06:00
updated: 2025-11-08T20:40:26-06:00
tags: []
aliases: []
---
# The skip_create, to_create, and initialize_with Methods

The `skip_create`, `to_create`, and `initialize_with` methods control how factory\_bot interacts with the [[§ strategies|Strategies]]

These methods can be called within a `factory` definition block, to scope their effects to just that factory; or within `FactoryBot.define`, to affect global change.

## `initialize_with`

The `initialize_with` method is used to initialize any object produced by the factory. 

The `initialize_with` method takes a block and returns an instance of the factory's class. It has access to the `attributes` method, which is a hash of all the fields and values for the object.

The default definition is:

```ruby
initialize_with { new }
```

See [[Custom Object Construction]] for information on customizing the `initialize_with` definition.

## `to_create`

 The `to_create` method is used to define how objects are persisted. It takes a block which takes the object and the factory\_bot context, and runs it for it's side effect. The context has additional data from any [[Transient Attributes|Transient Attribute]] definition blocks.

The default definition invokes `#save!` on the constructed object:

```ruby
to_create { |obj, context| obj.save! }
```

## `skip_create`

The `skip_create` method is a shorthand for turning `to_create` into a no-op. This allows you to use the `create` strategy as a synonym for `build`, except you additionally get any `create` hooks.