---
created: 2026-01-09T17:52:40-06:00
updated: 2026-02-28T09:48:30-06:00
type: note
tags: []
aliases: []
---
# Applying Traits to Objects at Construction Time

[[Traits]] can be applied to objects at construction time by passing in a list of Symbols which match the name of the desired traits.  

## Applying Traits When Constructing a Single Object

For example, when you create an object instance from factory\_bot, you can apply traits:

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

## Applying Traits When Constructing Lists of Objects

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
