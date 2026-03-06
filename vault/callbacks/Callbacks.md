---
type: note
created: 2025-11-07T19:08:51-06:00
updated: 2026-03-06T15:51:26-06:00
tags: []
aliases:
  - Callback
  - Callbacks
  - Callback Hook
  - Callback Hooks
  - Hook
  - Hooks
up: "[[§ Callbacks]]"
---
# Callbacks

**Callbacks**, also known as **Callback Hooks**, allow you to extend factories and include additional behavior at specific points in the construction process.

## Callback Events

FactoryBot makes the following callbacks available:

| Event            | Timing                                                                                                 |
| ---------------- | ------------------------------------------------------------------------------------------------------ |
| `:before_all`    | occurs before any strategy is used to construct an object or hash<br>(this includes custom strategies) |
| `:before_build`  | occurs before a factory **builds** an object<br>(via `FactoryBot.build` or `FactoryBot.create`)        |
| `:after_build`   | occurs after a factory **builds** an object<br>(via `FactoryBot.build` or `FactoryBot.create`)         |
| `:before_create` | occurs before a factory **saves** an object<br>(via `FactoryBot.create`)                               |
| `:after_create`  | occurs after a factory **saves** an object<br>(via `FactoryBot.create`)                                |
| `:after_stub`    | occurs after a factory **stubs** an object<br>(via `FactoryBot.build_stubbed`)                         |
| `:after_all`     | occurs after any strategy has completed<br>(this includes custom strategies)                           |

## Syntax

Within a `factory` definition block and the `FactoryBot.define` block, you have access to the `after`, `before`, and `callback` methods. These allow you to hook into lifecycle events that occur when a [[Build Strategy]] is invoked.

- Within a `factory` definition block, callbacks are scoped within that factory.
- Within a `FactoryBot.define` block, callbacks are globally available to all factories.

### The `callback` Method

The `callback` method allows you to hook into any factory\_bot callback by name. The pre-defined names are `before_all`, `after_build`, `before_create`, `after_create`, `after_stub`, and `after_all`.

```ruby
callback(:after_create) do |user, context|
  user.post_first_article(context.article)
end
```

The `callback` method takes a splat of names, and a block. The block is invoked any time one of the named callback events are activated. The block can be anything that responds to `#to_proc`.  This block takes two arguments: the instance of the factory, and the factory\_bot context. The context holds [[Transient Attributes]].

### The `after` and `before` Methods

The `after` and `before` methods add some nice syntax to `callback`:

```ruby
after(:create) do |user, context|
  user.post_first_article(context.article)
end
```

### Syntax Reference Table

The table below enumerates the ways in which a callback hook can be attached to each available callback event:

| Event            | Shorthand Callback Syntax | Alternate Callback Syntax  |
| ---------------- | ------------------------- | -------------------------- |
| `:before_all`    | `before(:all)`            | `callback(:before_all)`    |
| `:before_build`  | `before(:build)`          | `callback(:before_build)`  |
| `:after_build`   | `after(:build)`           | `callback(:after_build)`   |
| `:before_create` | `before(:create)`         | `callback(:before_create)` |
| `:after_create`  | `after(:create)`          | `callback(:after_create)`  |
| `:after_stub`    | `after(:stub)`            | `callback(:after_stub)`    |
| `:after_all`     | `after(:all)`             | `callback(:after_all)`     |

## Examples

### Calling an Object's Own Method after Building

The factory below calls a `generate_hashed_password` method after the factory is run using the build strategy:

```ruby
factory :user do
  after(:build) { |user, context| generate_hashed_password(user) }
end
```

Note that the callback provides both `user` (an instance of the object being constructed), and `context`.

### Skipping an Object's Own `:after_create` Callback

The example below demonstrates how the `before(:all)` and `after(:all)` callbacks can be used in conjunction to first disable an ActiveRecord model's `:after_create` callback that sends an email on creation, and then re-enable it afterward the factory run has completed:

```ruby
factory :user do
  before(:all){ User.skip_callback(:create, :after, :send_welcome_email) }
  after(:all){ User.set_callback(:create, :after, :send_welcome_email) }
end
```

## Notes

- The same callback name can be hooked into multiple times.
- Every block is run, in the order it was defined.
- Callbacks are inherited from their parents; the parents' callbacks are run first.
