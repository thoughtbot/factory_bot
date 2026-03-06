---
type: note
created: 2025-11-08T17:56:09-06:00
updated: 2026-02-28T09:40:29-06:00
tags: []
aliases:
  - Missing Methods
  - Missing Method
  - method_missing
up: "[[Attributes]]"
---
# Missing Methods Shorthand Syntax

**Unknown Methods**, also referred to as **Missing Methods**, are where a lot of the magic of FactoryBot happens. This behavior relies on Ruby metaprogramming, namely the `method_missing` feature.

Within a `factory` definition block, you can use `add_attribute`, `association`, `sequence`, and `trait` to define a factory. These methods are part of the explicit syntax available through the FactoryBot DSL. You can also, however, level a default `method_missing` definition for potential shortcuts.

## The `method_missing` Shorthand

Calling an unknown method (e.g. `name`, `admin`, `email`, `account`) invokes implicit behavior within the FactoryBot DSL to connect an association, sequence, trait, or attribute to the current factory. The type of connection is contextual and the code samples below illustrate the various possibilities:

- [[#Define an Attribute With a Block]]
- [[#Define an Attribute Using the Name of a Sequence]]
- [[#Define an Association By Matching the Name of Another Factory]]
- [[#Define an Association By Configuring the Factory]]
- [[#Activate a Trait]]

### Define an Attribute With a Block

When the missing method is passed a block, the declaration will always **define an attribute**. This allows you to set the value for the attribute:

```ruby
factory do
  name { "Sam" }
end
```

The code above demonstrates the creation of an [[Implicit Attributes|Implicit Attribute]].

### Define an Attribute Using the Name of a Sequence

When there is a global sequence of the same name, then the declaration will define an attribute with a value that pulls from the sequence.

```ruby
FactoryBot.define do
  sequence(:serial_number) { |n| n.to_s.rjust(15, '0') }
  
  factory :part do
    serial_number
  end
end
```

Notice how in this case, the block is omitted.

See [[Using Traits as Implicit Attributes]] for more information.

### Define an Association By Matching the Name of Another Factory

When there is another factory of the same name, then the declaration will define an association.

```ruby
factory :user
factory :membership do
  user
end
```

The code above defines an [[Implicit Associations]]. You may also include [[Association Overrides]] by passing in hash values as arguments.

### Define an Association By Configuring the Factory

When the missing method is passed a hash as a argument with the key `:factory`, then it always defines an association. This allows you to override the factory used for the association.

```ruby
factory :user
factory :book do
  author factory: :user
end
```

The code above is another example of an [[Implicit Associations]] as well as being an example of [[Specifying the Factory on Associations]]. Again, this syntax also supports the inclusion of [[Association Overrides]] by passing hash values in as arguments.

### Activate a Trait

If there is a trait of the same name for that factory, then the declaration will turn that trait on for all builds of the factory.


```ruby
factory :book do
  published
  
  trait :published do
    published { true }
  end
end
```

This is an example of [[Using Traits as Implicit Attributes]]

## Related

- [[Implicit Attributes]]
- [[Implicit Associations]]
- [[Using Traits as Implicit Attributes]]
- [[Swapping Explicit Syntax for Implicit Syntax]]
