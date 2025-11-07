---
type: note
created: 2025-08-29T16:22:49-05:00
updated: 2025-08-29T16:39:58-05:00
tags: []
aliases:
  - Customize a Factory
  - Modify a Factory
---
# Modify an Existing Factory

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

One approach is to create a child factory that inherits from the factory define by the gem developer:

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

## Caveats

It is important to note the following caveats to modifying factories:

- `FactoryBot.modify` must be called outside of a `FactoryBot.define` block as it operates on factories differently.
- only factories can be modified; not sequences or traits
- callbacks *still compound as they normally would*. So, if the factory you're modifying defines an `after(:create)` callback, you defining an `after(:create)` won't override it, it will instead be run after the first callback.
