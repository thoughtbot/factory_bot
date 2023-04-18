# Using traits

Traits can also be passed in as a list of Symbols when you construct an instance
from factory\_bot.

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

`create_list` and `build_list` methods are supported as well. Remember to pass
the number of instances to create/build as second parameter, as documented in
the "Building or Creating Multiple Records" section of this file.

```ruby
factory :user do
  name { "Friendly User" }

  trait :admin do
    admin { true }
  end
end

# creates 3 admin users with :active status and name "Jon Snow"
create_list(:user, 3, :admin, :active, name: "Jon Snow")
```
