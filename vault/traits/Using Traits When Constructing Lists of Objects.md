### Using Traits When Constructing Lists of Objects

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
