---
type: note
created: 2025-08-29T15:43:39-05:00
updated: 2026-01-09T17:38:03-06:00
tags: []
aliases:
  - build
  - build Strategy
  - Build Strategy
up: "[[Strategies]]"
---
# Build Strategy

The **Build Strategy** constructs an unsaved instance of the Factory's object class

## Syntax Methods

- `FactoryBot.build` constructs a single instance
- `FactoryBot.build_list` constructs multiple instances
- `FactoryBot.build_pair` is a shorthand to construct two instances

## Building Strategy

The `FactoryBot.build` method constructs an instance of the object class according to `initialize_with`, which defaults to calling the `.new` class method without any arguments.

- After it calls `initialize_with`, it invokes the `after_build` hook.
- [[Associations]] are constructed using the `build` construction strategy.

## Customization

- Override `initialize_with` to  [[Customize the Initialization of Objects]]
