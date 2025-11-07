---
type: note
created: 2025-08-29T15:44:14-05:00
updated: 2025-08-29T16:12:45-05:00
tags: []
aliases:
  - create
---
# `create` Strategy

The `FactoryBot.create` method constructs an instance of the class according to
`initialize_with`, and then persists it using `to_create`. The `.create_list`
class method constructs multiple instances, and `.create_pair` is a shorthand
to construct two instances.

After it calls `initialize_with`, it invokes the following hooks in order:

1. `after_build`
1. `before_create`
1. non-hook: `to_create`
1. `after_create`

Associations are constructed using the `create` build strategy.

The `to_create` hook controls how objects are persisted. It takes a block with
the object and the factory\_bot context, and runs it for its side effect. By
default, it calls `#save!`.