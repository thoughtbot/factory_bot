# Build strategies

factory\_bot supports several different build strategies: `build`, `create`,
`attributes_for` and `build_stubbed`:

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

# build_stubbed and Marshal.dump

Note that objects created with `build_stubbed` cannot be serialized with
`Marshal.dump`, since factory\_bot defines singleton methods on these objects.
