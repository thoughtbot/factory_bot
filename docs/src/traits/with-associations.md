# With associations

Traits can be used with associations easily too:

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
