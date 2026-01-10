---
type: note
created: 2026-01-09T17:25:33-06:00
updated: 2026-01-09T17:47:50-06:00
tags: []
aliases: []
---
# Disable the Persistence of Object Instances

The [[Create Strategy]] provides behavior to create and persist objects. The persistence can be disabled with `to_create` to mimic the [[Build Strategy]] while still invoking the create event callback hooks.

## The `skip_create` Method

The `skip_create` method is a macro method that can be invoked to turn `to_create` into a no-op. This allows you to use the `create` strategy as a synonym for `build`, except you additionally get any `create` hooks.

This method can be called within a `factory` definition block, to scope it's effects to just that factory; or within `FactoryBot.define`, to affect global change.

## Example

To disable the persistence method altogether on create, you can `skip_create` for that factory:

```ruby
factory :user_without_database do
  skip_create
end
```