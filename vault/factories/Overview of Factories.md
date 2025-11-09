---
type: note
created: 2025-11-08T14:48:25-06:00
updated: 2025-11-08T21:13:57-06:00
tags: []
aliases:
  - factories
  - factory
---
# Overview of Factories

A **Factory** is used to construct example objects

## Syntax

The FactoryBot DSL provides a `factory` method that's used to define new factories. New factories are defined within a `FactoryBot.define` block. Existing factories can be modified within a `FactoryBot.modify` block. Anything defined using `factory` can be built using a [build strategy](build-strategies.html).

```ruby
FactoryBot.define do
  factory :user do
    first_name { "Test" }
    last_name { "Tester" }
    email { "test@example.com" }
  end
end
```

The `factory` method takes three arguments: a required name, an optional hash of options, and an optional block. The name is expected to be a Symbol.

### Factory Options

| option     | description                                                                                                                                                                                                                                                                  |
| ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `:class`   | configures the class to construct. This can be a class, String, Symbol, or anything that responds to `#to_s`. By default, FactoryBot will either use the parent factory's class or automatically maps the name of the factory to a class that matches the naming convention. |
| `:parent`  | configures the name of a factory this factory should inherit from. This defaults to `nil` to indicate the factory does not inherit from any other factory.                                                                                                                   |
| `:aliases` | configures a list of alternative names for this factory. Any of these names can be used with a build strategy. Defaults to an empty list (`[]`).                                                                                                                             |
| `:traits`  | configures a list of base traits to use by default when running this factory. Defaults to an empty list (`[]`).                                                                                                                                                              |

## Factory DSL

Within the `factory` block you have access to the following methods:

- `add_attribute` – define [[Explicit Attributes]]
- `association` – define [[Explicit Associations]]
- `sequence` – define [[Factory Sequences]]
- `trait` – define [[§ traits|Traits]]
- `transient` – start a [[Transient Attributes]] block
- `traits_for_enum` – define a set of [[Enum Traits]]
- `initialize_with` – customize how the object is initialized
- `skip_create` – skips the default `to_create` operation
- `to_create` – customize how the object is persisted
- `before` – adds a [[§ callbacks|Callback]] hook before an event
- `after` – adds a [[§ callbacks|Callback]] hook after an event
- `callback` – adds a [[§ callbacks|Callback]] hook
- `factory` – to implicitly define [[Child Factories]]

 You also have access to [[Unknown Methods|Missing Methods]] to implicitly declare attributes; declare associations; or activate traits.
