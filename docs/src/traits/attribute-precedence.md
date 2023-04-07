# Attribute precedence

Traits that define the same attributes won't raise AttributeDefinitionErrors;
the trait that defines the attribute last gets precedence.

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

  factory :active_admin,   traits: [:active, :admin]   # login will be "admin-John Doe"
  factory :inactive_admin, traits: [:admin, :inactive] # login will be "Jane Doe (inactive)"
end
```
