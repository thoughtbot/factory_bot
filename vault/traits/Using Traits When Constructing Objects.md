---
created: 2026-01-09T17:52:40-06:00
updated: 2026-01-09T17:53:31-06:00
type: note
tags: []
aliases: []
---
# Using Traits When Constructing Objects

[[Traits]] can be passed in as a list of Symbols when you construct an instance from factory\_bot.

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