---
type: note
created: 2025-08-29T15:33:57-05:00
updated: 2025-08-29T16:21:11-05:00
tags: []
aliases:
---
# Using a Factory

## Build Strategies

FactoryBot supports several different build strategies: 

- [[build Strategy|build]]
- [[create Strategy]]
- [[build_stubbed Strategy]]
-  [[attributes_for Strategy]]
- [[null Strategy]]

Here's several examples demonstrating their usage:

```ruby
# Returns a User instance that's not saved
user = build(:user)

# Returns a saved User instance
user = create(:user)

# Returns a hash of attributes, which can be used to build a User instance for example
attrs = attributes_for(:user)

# Integrates with Ruby 3.0's support for pattern matching assignment
attributes_for(:user) => {email:, name:, **attrs}

# Returns an object with all defined attributes stubbed out
stub = build_stubbed(:user)

# Passing a block to any of the methods above will yield the return object
create(:user) do |user|
  user.posts.create(attributes_for(:post))
end
```

