---
type: note
created: 2026-01-09T17:18:06-06:00
updated: 2026-03-06T16:07:33-06:00
tags: []
aliases: []
---
# Customizing the Persistence of Object Instances

FactoryBot provides the means to customize the manner with which objects are persisted. FactoryBot normally persists constructed objects when the [[Create Strategy]] is used to run a [[§ Factories|Factory]].

## The `to_create` Method

 FactoryBot defines a `to_create` method which is used to manage how objects are persisted. It takes a block which accepts the object and the factory\_bot context, and runs this block for it's side effect. The context is passed to provide additional data from any [[Transient Attributes|Transient Attribute]] definition blocks.

This method can be called within a `factory` definition block, to scope it's effects to just that factory; or within `FactoryBot.define`, to affect global change.

### Default Definition

The default definition invokes `#save!` on the constructed object:

```ruby
to_create { |obj, context| obj.save! }
```

## Override a Single Factory

When employing the [[create Strategy|create]] strategy during a Factory run, by default, the creation of the record will result in `save!` being called on the object instance; since this may not always be ideal, you can override that behavior by defining `to_create` on the factory:

```ruby
factory :different_orm_model do
  to_create { |instance| instance.persist! }
end
```

## Override Persistence For All Factories

To override `to_create` for all factories, define it within the `FactoryBot.define` block:

```ruby
FactoryBot.define do
  to_create { |instance| instance.persist! }


  factory :user do
    name { "John Doe" }
  end
end
```

## Related

- for information on disabling persistence, see [[Disabling the Persistence of Object Instances]]
