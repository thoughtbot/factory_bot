---
type: note
created: 2025-08-29T15:44:14-05:00
updated: 2025-11-08T21:23:43-06:00
tags: []
aliases:
  - create
  - create Strategy
  - The create Strategy
---
# The `create` Strategy

The `FactoryBot.create` method constructs an instance of the class according to `initialize_with`, and then persists it using `to_create`. Factories can opt out of persistence with the `skip_create` method.

See [[The skip_create, to_create, and initialize_with Methods]] for more about these methods.

## Order of Callback Hooks

After the strategy calls `initialize_with`, it invokes the following hooks in order:

1. `after_build`
1. `before_create`
1. non-hook: `to_create`
1. `after_create`

## Notes

- Associations are constructed using the `create` construction strategy.

## Object Persistence

The create strategy persists the objects it constructs by saving them to the database. The `to_create` hook controls how objects are persisted. 

## Skipping Persistence

The `skip_create` method is a shorthand for turning `to_create` into a no-op. This allows you to use the `create` strategy as a synonym for `build`, except you additionally get any `create` hooks.

## Creating Pairs of Objects

The `.create_list` class method constructs multiple instances, and `.create_pair` is a shorthand to construct two instances.
