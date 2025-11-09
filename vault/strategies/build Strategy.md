---
type: note
created: 2025-08-29T15:43:39-05:00
updated: 2025-11-08T21:25:44-06:00
tags: []
aliases:
  - build
  - build Strategy
  - The build Strategy
up: "[[§ strategies|Strategies]]"
---
# The `build` Strategy

The `FactoryBot.build` method constructs an instance of the object class according to
`initialize_with`, which defaults to calling the `.new` class method without any arguments.

- `FactoryBot.build_list` constructs multiple instances
- `FactoryBot.build_pair` is a shorthand to construct two instances.
- After it calls `initialize_with`, it invokes the `after_build` hook.
- Associations are constructed using the `build` construction strategy.