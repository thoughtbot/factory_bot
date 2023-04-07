# Modifying factories

If you're given a set of factories (say, from a gem developer) but want to
change them to fit into your application better, you can modify that factory
instead of creating a child factory and adding attributes there.

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

Instead of creating a child factory that added additional attributes:

```ruby
FactoryBot.define do
  factory :application_user, parent: :user do
    full_name { "Jane Doe" }
    date_of_birth { 21.years.ago }
    health { 90 }
  end
end
```

You could modify that factory instead.

```ruby
FactoryBot.modify do
  factory :user do
    full_name { "Jane Doe" }
    date_of_birth { 21.years.ago }
    health { 90 }
  end
end
```

When modifying a factory, you can change any of the attributes you want (aside from callbacks).

`FactoryBot.modify` must be called outside of a `FactoryBot.define` block as it
operates on factories differently.

A caveat: you can only modify factories (not sequences or traits), and
callbacks *still compound as they normally would*. So, if the factory you're
modifying defines an `after(:create)` callback, you defining an
`after(:create)` won't override it, it will instead be run after the first
callback.
