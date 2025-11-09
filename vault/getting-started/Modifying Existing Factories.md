---
type: note
created: 2025-08-29T16:22:49-05:00
updated: 2025-11-08T18:59:04-06:00
tags: []
aliases:
  - Customize a Factory
  - Modify a Factory
---
# Modifying Existing Factories

The `FactoryBot.modify` class method accepts a block where an _overriding_ `factory` method is made available. That is the only method you can call within the block.

## Example: Modifying Factories From a Gem

If you're given a set of factories — say, from a gem developer — but want to change them to fit into your application better, you can modify that factory instead of creating a child factory and adding attributes there.

If a gem were to give you a User factory:

```ruby
FactoryBot.define do
  factory :user do
    full_name { "John Doe" }
    sequence(:username) { |n| "user#{n}" }
    password { "password" }
  end
end
```

Were you to try and redefine this user factory inside a `FactoryBot.define` block, FactoryBot would raise an error. How then could you add additional attributes?

### Extension Through Inheritance

One approach is to create a child factory that inherits from the factory defined by the gem developer:

```ruby
FactoryBot.define do
  factory :application_user, parent: :user do
    full_name { "Jane Doe" }
    date_of_birth { 21.years.ago }
    health { 90 }
  end
end
```

This could be useful when the need exists to retain the ability to construct objects with both the original `user` factory in addition to the extended `application_user` factory.

### Extending the Original Factory

It is possible, however, to modify the original factory, instead of creating a child factory, in order to add additional attributes:

```ruby
FactoryBot.modify do
  factory :user do
    full_name { "Jane Doe" }
    date_of_birth { 21.years.ago }
    health { 90 }
  end
end
```

The difference here is the use of `FactoryBot.modify` which allows existing factories to be extended. When modifying a factory, you can change any of the attributes you want (aside from callbacks).

## Technical Notes

It is important to note the following in regards to modifying factories:

- `FactoryBot.modify` must be called outside of a `FactoryBot.define` block as it operates on factories differently.
- Only factories can be modified; not sequences or traits
- The `factory` method within this block takes a mandatory factory name, and a block. All other arguments are ignored. 
    - The factory name must already be defined. 
    - The block is a normal [[§ factories|factory definition block]]. 
- Take note that [[§ callbacks|Callback]] hooks cannot be cleared.
- Callbacks also continue to _compound as they normally would_. 
    - So, if the factory you're modifying defines an `after(:create)` callback, you defining an `after(:create)` won't override it, it will instead be run after the first callback.

