---
type: note
created: 2025-08-29T15:43:39-05:00
updated: 2025-08-29T16:11:07-05:00
tags: []
aliases:
  - build
---
# `build` Strategy

The `FactoryBot.build` method constructs an instance of the class according to
`initialize_with`, which defaults to calling the `.new` class method.
`.build_list` constructs multiple instances, and `.build_pair` is a shorthand
to construct two instances.

After it calls `initialize_with`, it invokes the `after_build` hook.

Associations are constructed using the `build` build strategy.