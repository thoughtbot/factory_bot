---
type: note
created: 2025-11-07T21:10:45-06:00
updated: 2025-11-08T20:23:34-06:00
tags: []
aliases:
---
# Overview of Traits

## Introduction

Traits allow you to group attributes together and apply them to a factory

- [[Factory Traits]] define a factory-scoped group of attributes scoped used on any factory
- [[Global Traits]] define a globally-scoped group of attributes used as a mixins to any factory
- [[Enum Traits]] define a group of traits for every possible value of an enum

## Syntax

Within a `factory` definition block, the `trait` method can be used to define named permutations of the factory. The trait method takes a name (Symbol) and a block. Treat the block like you would a [[§ factories|Factory]] definition block.

### Using Traits When Constructing Objects

Traits can also be passed in as a list of Symbols when you construct an instance from factory\_bot.

```ruby
factory :user do
  name { "Friendly User" }

  trait :active do
    name { "John Doe" }
    status { :active }
  end

  trait :admin do
    admin { true }
  end
end

# creates an admin user with :active status and name "Jon Snow"
create(:user, :admin, :active, name: "Jon Snow")
```

This ability works with `build`, `build_stubbed`, `attributes_for`, and `create`.

### Using Traits When Constructing Lists of Objects

The `create_list` and `build_list` methods are supported as well. Remember to pass the number of instances to create/build as second parameter (as documented in [[Building or Creating Multiple Objects]]).

```ruby
factory :user do
  name { "Friendly User" }

  trait :active do
    name { "John Doe" }
    status { :active }
  end

  trait :admin do
    admin { true }
  end
end

# creates 3 admin users with :active status and name "Jon Snow"
create_list(:user, 3, :admin, :active, name: "Jon Snow")
```
