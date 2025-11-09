---
type: note
created: 2025-11-07T19:08:51-06:00
updated: 2025-11-08T21:20:56-06:00
tags: []
aliases: []
---
# Overview of Callbacks

**Callback hooks** allow you to extend factories and include additional behavior at specific points in the construction process.

FactoryBot makes the following callbacks available:

| Callback          | Timing                                                                                                 |
| ----------------- | ------------------------------------------------------------------------------------------------------ |
| `before(:all)`    | called before any strategy is used to construct an object or hash<br>(this includes custom strategies) |
| `before(:build)`  | called before a factory **builds** an object<br>(via `FactoryBot.build` or `FactoryBot.create`)        |
| `after(:build)`   | called after a factory **builds** an object<br>(via `FactoryBot.build` or `FactoryBot.create`)         |
| `before(:create)` | called before a factory **saves** an object<br>(via `FactoryBot.create`)                               |
| `after(:create)`  | called after a factory **saves** an object<br>(via `FactoryBot.create`)                                |
| `after(:stub)`    | called after a factory **stubs** an object<br>(via `FactoryBot.build_stubbed`)                         |
| `after(:all)`     | called after any strategy has completed<br>(this includes custom strategies)                           |

## Methods

Within a `factory` definition block and the `FactoryBot.define` block, you have access to the `after`, `before`, and `callback` methods. These allow you to hook into parts of the [[build strategies]].

- Within a `factory` definition block, these callbacks are scoped to just that factory. 
- Within a `FactoryBot.define` block, they are global to all factories.

## The `callback` Method

The `callback` method allows you to hook into any factory\_bot callback by name. The pre-defined names are `before_all`, `after_build`, `before_create`, `after_create`, `after_stub`, and `after_all`.

```ruby
callback(:after_create) do |user, context|
  user.post_first_article(context.article)
end
```

This method takes a splat of names, and a block. It invokes the block any time one of the named callback events are activated. The block can be anything that responds to `#to_proc`.  This block takes two arguments: the instance of the factory, and the factory\_bot context. The context holds [[Transient Attributes]].

## The `after` and `before` Methods

The `after` and `before` methods add some nice syntax to `callback`:

```ruby
after(:create) do |user, context|
  user.post_first_article(context.article)
end
```

## Example: Calling an Object's Own Method after Building

The factory below calls a `generate_hashed_password` method after the factory is run using the build strategy:

```ruby
factory :user do
  after(:build) { |user, context| generate_hashed_password(user) }
end
```

Note that the callback provides both `user` (an instance of the object being constructed), and `context`.

## Example: Skipping an Object's Own :after_create Callback

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
