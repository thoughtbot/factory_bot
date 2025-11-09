---
type: note
created: 2025-11-07T21:32:40-06:00
updated: 2025-11-07T21:35:16-06:00
tags: []
aliases: []
---
# Attribute Precedence Across Traits

Using multiple traits that each define the same attributes will not raise an `AttributeDefinitionError`. Rather, the trait that defines the attribute last is given precedence.

```ruby
factory :user do
  name { "Friendly User" }
  login { name }

  trait :active do
    name { "John Doe" }
    status { :active }
    login { "#{name} (active)" }
  end

  trait :inactive do
    name { "Jane Doe" }
    status { :inactive }
    login { "#{name} (inactive)" }
  end

  trait :admin do
    admin { true }
    login { "admin-#{name}" }
  end

  # login will be "admin-John Doe"
  factory :active_admin, traits: [:active, :admin]   
  
  # login will be "Jane Doe (inactive)"
  factory :inactive_admin, traits: [:admin, :inactive] 
end
```
