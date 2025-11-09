---
type: note
created: 2025-11-07T14:31:55-06:00
updated: 2025-11-08T20:11:36-06:00
tags: []
aliases: []
---
# Transient Attributes

Transient attributes are attributes only available within the factory definition, and not set on the object being built. This allows for more complex logic inside factories.

These are defined within a `transient` block:

```ruby
factory :user do
  name { "Zero Cool" }
  birth_date { age&.years.ago }

  transient do
    age { 11 }
  end
end
```

In the example above, the `age` attribute is only used to compute and set the value of `birth_date`. It will not be assigned to the product that is constructed.

## When To Use

Within a `factory` definition block, the goal is to construct an instance of the configured object class. While factory\_bot does this, it keeps track of data in a context. **Transient Attributes** facilitate setting data on this context through the use a `transient` block.

A `transient` block can be treated like a `factory` definition block. However, none of the attributes, associations, traits, or sequences you set will impact the final object constructed by the factory.

**Transient Attributes** are useful for altering and overriding values used internally by the Factory. For instance, when using the `:user` factory from above, the constructed `User`  instance can be provided an `age` rather than a `birth_date`:

```ruby
FactoryBot.build(:user, age: 21)
```

## Ignored by The `attributes_for` Strategy

**Transient Attributes** will be ignored when employing the `attributes_for` strategy and will not be set on the hash that is produced. This is remains true even when the model contains an attribute matching the same name or when you attempt to override it.

## Notes

- **Transient Attributes** are most useful when paired with [[§ callbacks|Callback]] hooks or `to_create`
- [[Using Transient Attributes Within Callbacks]]
- [[Using Transient Attributes Within Other Attributes]]
- [[Using Associations Within Transient Attributes]]
