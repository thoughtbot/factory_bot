---
type: note
created: 2025-11-08T17:56:09-06:00
updated: 2025-11-08T19:09:08-06:00
tags: []
aliases:
  - Unknown Method
  - Missing Method
  - method_missing
  - Missing Methods
---
# Unknown Methods

**Unknown Methods**, also referred to as **Missing Methods**, are where a lot of the magic of FactoryBot happens. This behavior relies on Ruby metaprogramming, namely the `method_missing` feature.

Within a `factory` definition block, you can use `add_attribute`, `association`, `sequence`, and `trait` to define a factory. These methods are part of the explicit syntax available through the FactoryBot DSL. You can also, however, level a default `method_missing` definition for potential shortcuts.
## The `method_missing` Shorthand

Calling an unknown method (e.g. `name`, `admin`, `email`, `account`) invokes implicit behavior within the FactoryBot DSL to connect an association, sequence, trait, or attribute to the current factory. The type of connection is contextual and the code samples below illustrate the various possibilities.

### Defining an Attribute With a Block

When the missing method is passed a block, it always **defines an attribute**. This allows you to set the value for the attribute:

```ruby
factory do
  name { "Sam" }
end
```

The code above defines an [[Implicit Attributes|Implicit Attribute]].

### Defining an Attribute Using the Name of a Sequence

When there is a global sequence of the same name, then it defines an attribute with a value that pulls from the sequence.

```ruby
FactoryBot.define do
  sequence(:serial_number) { |n| n.to_s.rjust(15, '0') }
  factory :part do
    serial_number
  end
end
```

Notice how in this case, the block is not required. Also, you may refer to [[Using Traits as Implicit Attributes]] for more information.

### Defining an Association By Matching the Name of Another Factory

When there is another factory of the same name, then it defines an association.

```ruby
factory :user
factory :membership do
  user
end
```

The code above defines an [[Implicit Associations]]. You may also include [[Association Overrides]] by passing in hash values as arguments.

### Defining an Association By Configuring the Factory

When the missing method is passed a hash as a argument with the key `:factory`, then it always defines an association. This allows you to override the factory used for the association.

```ruby
factory :user
factory :book do
  author factory: :user
end
```

The code above is another example of an [[Implicit Associations]]. Again, this syntax also supports the inclusion of [[Association Overrides]] by passing hash values in as arguments.

### Activating a Trait

If there is a trait of the same name for that factory, then it turns that trait on for all builds of this factory.

## Example: Swapping Explicit Syntax for Implicit Syntax

### Original Code Using Explicit Syntax

The code sample below demonstrates the definition of a Factory using exclusively explicit syntax methods:

```ruby
FactoryBot.define do
  sequence(:email) { |n| "person#{n}@example.com" }
  factory :account
  factory :organization

  factory :user, traits: [:admin] do
    add_attribute(:name) { "Lord Nikon" }
    add_attribute(:email) { generate(:email) }
    association :account
    association :org, factory: :organization

    trait :admin do
      add_attribute(:admin) { true }
    end
  end
end
```

### Rewritten Using Implicit Definition Syntax

Using the `method_missing` shorthand, however, can turn the explicit definition above into a more implicit definition:

```ruby
FactoryBot.define do
  sequence(:email) { |n| "person#{n}@example.com" }
  factory :account
  factory :organization

  factory :user do
    name { "Lord Nikon" }      # no more `add_attribute`
    admin                      # no more :traits
    email                      # no more `add_attribute`
    account                    # no more `association`
    org factory: :organization # no more `association`

    trait :admin do
      admin { true }
    end
  end
end
```


