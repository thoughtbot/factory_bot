---
type: note
created: 2025-08-29T15:44:14-05:00
updated: 2026-01-09T17:58:58-06:00
tags: []
aliases:
  - create
  - create Strategy
  - The create Strategy
up: "[[Strategies]]"
---
# Create Strategy

The `FactoryBot.create` method constructs an instance of the class according to `initialize_with`, and then persists it using `to_create`. Factories can opt out of persistence with the `skip_create` method.

## Syntax Methods

- `FactoryBot.create` creates a single instance
- `FactoryBot.create_pair` creates a pair of instances
- `FactoryBot.create_list` creates multiple instances

## Creation Strategy

The **Create Strategy** initially constructs a new instance of the Object Class – in the same manner as the [[Build Strategy]]. It then persists the objects it constructs by saving them to the database. The `to_create` hook controls how objects are persisted. 

- Associations are constructed using the `create` construction strategy.

## Order of Callback Hooks

After the strategy calls `initialize_with`, it invokes the following hooks in order:

1. `after_build`
1. `before_create`
1. non-hook: `to_create`
1. `after_create`

## Customization

- Override `initialize_with` to  [[Customize the Initialization of Objects]]
- Override `to_create` to [[Customize the Persistence of Object Instances]]
- Invoke `skip_create` to [[Disable the Persistence of Object Instances]]