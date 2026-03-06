---
type: note
created: 2025-08-29T15:00:15-05:00
updated: 2026-03-06T15:10:03-06:00
tags: []
aliases:
  - Defining a factory
  - Define a factory
up: "[[Getting Started]]"
---
# Factories

A **Factory** is used to construct example objects.

## Defining a Factory

**Factories** are defined by invoking the `factory` DSL inside the scope of a block passed into `FactoryBot.define`. Each factory must be given a name and a set of attributes. The factory's name is used to guess the class of the object by default. The set of attributes will be assigned to the product that is produced, or constructed, by the factory at runtime.

Here's an example:

```ruby
FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name  { "Doe" }
    admin { false }
  end
end
```

The example above demonstrates how each factory should be defined with a name and a set of attributes. The factory is given a name of `:user`, and this will be used to guess the class of the object by default. When the factory is run, an instance of the class `User` will be constructed and then assigned the attributes of `first_name`, `last_name`, and `admin`.

## Loading Factories

FactoryBot defines a default, but configurable, [[Factory Load Order]] to load in factory definitions. When using `factory_bot-rails`, factory definitions found in the configured locations will load automatically. Outside of Rails, however, you may need to invoke `FactoryBot.find_definitions`.

See [[Factory Load Order]] for details.

## Using Factories

Once a [[§ Factories|Factory]] is defined, objects and hashes can be constructed using any of the built-in [[Strategies]], or a [[Custom Strategies|Custom Strategy]]. Some [[Common Factory Use Cases]] include building unsaved objects; creating saved objects; stubbing objects; or constructing a hash of attributes.

For example, an unsaved User instance can be constructed with the `:user` factory (defined earlier) by invoking `build`:

```ruby
example_user = build(:user)
```

See [[Common Factory Use Cases]] for further demonstration.

## Modifying Factories

Factory definitions can be modified using `FactoryBot.modify` class method which accepts a block where an _overriding_ `factory` method is made available.

For more information, see [[Modifying Existing Factories]]

## Related

See [[§ Factories]] to explore more about how to work with factories within FactoryBot.

Some useful pages to start with are listed below:

- [[Factory Naming Conventions]]
- [[Factory Definition File Paths]]
- [[Explicit Specification of a Factory's Class]]
- [[Factory Best Practices]]
