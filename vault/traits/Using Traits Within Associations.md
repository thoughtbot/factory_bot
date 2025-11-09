---
type: note
created: 2025-11-07T21:38:09-06:00
updated: 2025-11-07T21:43:24-06:00
tags: []
aliases: []
---
# Using Traits Within Associations

## Basic Usage

Traits can be used with associations by including a list of the traits as symbols within the invocation of `association` like so:

```ruby
factory :user do
  name { "Friendly User" }

  trait :admin do
    admin { true }
  end
end

factory :post do
  association :user, :admin, name: 'John Doe'
end

# creates an admin user with name "John Doe"
create(:post).user
```

The syntax is virtually identical to using the syntax methods of the various construction strategies.

## Including Traits When Declaring An Explicit Factory


When you're using association names that are different than the factory:

```ruby
factory :user do
  name { "Friendly User" }

  trait :admin do
    admin { true }
  end
end

factory :post do
  association :author, :admin, factory: :user, name: 'John Doe'
  # or
  association :author, factory: [:user, :admin], name: 'John Doe'
end

# creates an admin user with name "John Doe"
create(:post).author
```
