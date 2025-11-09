---
type: note
created: 2025-11-07T19:14:56-06:00
updated: 2025-11-07T19:20:51-06:00
tags: []
aliases: []
---
# Using Multiple Callbacks

## Using Multiple Callback Types

It's possible to define multiple types of callbacks on the same factory:

```ruby
factory :user do
  after(:build)  { |user| do_something_to(user) }
  after(:create) { |user| do_something_else_to(user) }
end
```

## Multiple Instances of the Same Callback Type

Factories can also define any number of the same kind of callback. These
callbacks will be executed in the order they are specified:

```ruby
factory :user do
  after(:create) { this_runs_first }
  after(:create) { then_this }
end
```

## Callbacks Are Inherited

Like standard attributes, child factories inherit callbacks from their parent factory. Child factories can also define their own callbacks.

## Assigning the Same Block To Multiple Callbacks

Multiple callbacks can be assigned to run a block; this is useful when building various strategies that run the same code.

```ruby
factory :user do
  callback(:after_stub, :before_create) { do_something }
  after(:stub, :create) { do_something_else }
  before(:create, :custom) { do_a_third_thing }
end
```

## Notes

- Calling [[create Strategy|create]] will invoke both `after_build` and `after_create` callbacks.